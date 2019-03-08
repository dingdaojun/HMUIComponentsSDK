//  HMStatisticsNamedTask.m
//  Created on 2018/4/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsNamedTask.h"
#import "HMStatisticsConfig.h"
#import "HMStatisticsTools.h"
#import "HMStatisticsReachability.h"
#import "HMStatisticsTools+Encrypt.h"
#import "HMStatisticsTools+DeviceInfo.h"
#import "HMStatisticsNamedManager.h"
#import "HMStatisticsNamedRecord.h"
#import "HMStatisticsNamedContextRecord.h"
#import "HMStatisticsTimer.h"
#import "HMStatisticsDefine.h"

//每次最大上传数
static const NSInteger  maxNamedEventNumberPerUpload = 100;
static NSString *namedUploadURL = @"https://api-analytics.huami.com/api/v3/app/collect_hm/ios";
static NSString *namedDubugUploadURL = @"https://api-analytics-test.huami.com/api/v3/app/collect_hm/ios";
static NSString *kNamedTotalTraffic = @"kNamedTotalTraffic";

@interface HMStatisticsNamedTask()

@property(strong, nonatomic) NSOperationQueue   *operationQueue;
@property(strong, nonatomic) NSURLSession       *urlSession;
@property(strong, nonatomic) HMStatisticsTimer  *timer;
@property(strong, nonatomic) HMStatisticsConfig *config;
@property(strong, nonatomic) dispatch_queue_t   hmNamedGCD;
@property(assign, nonatomic, readwrite) BOOL  isServiceStart;

@end

@implementation HMStatisticsNamedTask

# pragma mark - 主接口

+ (instancetype)sharedInstance {
    static HMStatisticsNamedTask *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HMStatisticsNamedTask alloc] init];
        shareInstance.operationQueue = [[NSOperationQueue alloc] init];
        shareInstance.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
        shareInstance.hmNamedGCD = dispatch_queue_create("hm.statistics.named",NULL);
        shareInstance.isServiceStart = NO;
    });

    return shareInstance;
}

- (NSString *)configUserID {
    if (_config && _config.huamiID) {
        return _config.huamiID;
    }

    return @"";
}

/**
 获取配置渠道 ID
 
 @return 返回配置 ChannelID
 */
- (NSString *)configChannelID {
    if (!_config) {
        return @"";
    }
    
    return [HMStatisticsTools convertToSafeString:_config.channelID];
}

- (void)startOperationWithConfig:(HMStatisticsConfig *)config {
    // 停止任务
    [self stopOperation];

    // 重新设置任务
    self.config = config;

    if (!_config || !_config.huamiID || [_config.huamiID isEqualToString:@""] ) {
        return;
    }

    if(config.reportPolicy == HMStatisticsReportPolicyFinishLaunching) {
        // 延迟执行，预防 UI 卡顿
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(90 * NSEC_PER_SEC)), self.hmNamedGCD, ^{
            [self processFinishLaunchingEventLog];
        });
    }

    if(config.reportPolicy == HMStatisticsReportPolicySendInterval) {
        // 设置定时器
        _timer = [HMStatisticsTimer timerRepeatintWithTimeInterval:config.minSendInterval block:^{
            dispatch_async(self.hmNamedGCD, ^{
                [self processSendIntervalEventLog];
            });
        }];
    }

    // 监听前后台切换事件，优化上传策略（主要应对数据延时和定时器重启）
    NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
    [nCenter addObserver:self selector:@selector(deactiveService) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [nCenter addObserver:self selector:@selector(activeSercice) name:UIApplicationWillEnterForegroundNotification object:nil];

    self.isServiceStart = YES;
}

/**
 关闭操作
 */
- (void)stopOperation {
    [self clearService];

    // NotificationCenter 移除通知项
    NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
    [nCenter removeObserver:self];

    // 重制配置项
    _config = nil;

    self.isServiceStart = NO;
}

/**
 实名流量消耗

 @return 实名流量消耗
 */
- (double)totalTraffic {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kNamedTotalTraffic];
}

# pragma mark - 策略优化
/**
 激活服务
 */
- (void)activeSercice {
    [self clearService];

    if (!_config || !_config.huamiID) {
        return;
    }

    if(_config.reportPolicy == HMStatisticsReportPolicySendInterval) {
        // 设置定时器
        if (self.timer && self.timer.timerStatus == HMStatisticsTimerStatusSuspend) {
            // 重启定时任务
            [self.timer resumeTask];
        }
    }
}

/**
 反激活服务
 */
- (void)deactiveService {
    [self clearService];

    if (!_config || !_config.huamiID) {
        return;
    }

    dispatch_async(self.hmNamedGCD, ^{
        [self processSendIntervalEventLog];
    });
}

/**
 清空已有任务及定时器
 */
- (void)clearService {
    [self.operationQueue cancelAllOperations];

    if (self.timer && self.timer.timerStatus == HMStatisticsTimerStatusResume) {
        // 暂停定时任务
        [self.timer suspendTask];
    }
}

# pragma mark - 各个策略的上传处理
/**
 启动时上传操作，直接上传不进行数据量限制
 */
- (void)processFinishLaunchingEventLog {

    if (!_config || !_config.huamiID) {
        return;
    }

    // 检查网络状态
    if (![self checkNetStatus]) {
        return;
    }

    HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];

    [manager asyncFetchAllNamedEventWithGroup:^(NSArray<NSArray<HMStatisticsNamedRecord *> *> * _Nonnull groupReslut, NSArray<HMStatisticsNamedContextRecord *> * _Nonnull groupContext) {
        NSAssert(groupContext.count == groupReslut.count, @"context must be equal to grooupresult");
        
        if (groupContext.count < 1) {
            return;
        }
        
        NSInteger index = 0;
        
        for (NSArray *oneGroup in groupReslut) {
            [self generateTaskWithOneGroup:oneGroup andContext:[groupContext objectAtIndex:index]];
            index++;
        }
        
    }];
}

/**
 定时上传
 */
- (void)processSendIntervalEventLog {

    if (!_config || !_config.huamiID) {
        return;
    }

    // 检查网络状态
    if (![self checkNetStatus]) {
        return;
    }

    HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];

    [manager asyncFetchAllNamedEventWithGroup:^(NSArray<NSArray<HMStatisticsNamedRecord *> *> * _Nonnull groupReslut, NSArray<HMStatisticsNamedContextRecord *> * _Nonnull groupContext) {
        NSAssert(groupContext.count == groupReslut.count, @"context must be equal to grooupresult");
        
        if (groupContext.count < 1) {
            return;
        }
        
        NSInteger allEventSum = 0;
        BOOL fulfil = NO;
        for (NSArray *oneGroup in groupReslut) {
            allEventSum += oneGroup.count;
            
            // 获取最早的数据记录
            HMStatisticsNamedRecord *firstRecord = [oneGroup firstObject];
            double seconds = [[NSDate date] timeIntervalSince1970];
            double secondsBefore = (firstRecord.eventTimestamp / 1000.0 ) - seconds;
            
            if (secondsBefore > (1440 * 60) ) {
                fulfil = YES;
                break;
            }
        }
        
        if (allEventSum < 20 && !fulfil) {
            return;
        }
        
        NSInteger index = 0;
        
        for (NSArray *oneGroup in groupReslut) {
            [self generateTaskWithOneGroup:oneGroup andContext:[groupContext objectAtIndex:index]];
            index++;
        }
        
        return;
    }];
}

- (void)processRealTimeEventLog:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context {
    if(!_config) {
        return;
    }

    if (!_config.isDebug || _config.reportPolicy != HMStatisticsReportPolicyRealTime) {
        return;
    }

    // 检查网络状态
    if (![self checkNetStatus]) {
        return;
    }

    NSOperation *operation = [self operationTaskWithEvents:events withContext:context];

    if (operation) {
        [self.operationQueue addOperation:operation];
    }

    return;
}

- (void)generateTaskWithOneGroup:(NSArray<HMStatisticsNamedRecord *> *)result andContext:(HMStatisticsNamedContextRecord *)context {
    
    if (result.count < 1) {
        return;
    }
    
    NSInteger groupCount = (result.count - 1) / maxNamedEventNumberPerUpload + 1;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < groupCount; index++) {
        NSInteger subMaxIndex = MIN(result.count, (index + 1) * maxNamedEventNumberPerUpload );
        
        NSArray *subArray = [result subarrayWithRange:NSMakeRange(index * maxNamedEventNumberPerUpload, subMaxIndex - index * maxNamedEventNumberPerUpload)];
        [groupArray addObject:subArray];
    }
    
    NSMutableArray *allOperations = [NSMutableArray array];
    for (NSArray *subArray in groupArray) {
        NSOperation *operation = [self operationTaskWithEvents:subArray withContext:context];
        
        if (operation) {
            [allOperations addObject:operation];
        }
    }
    
    for (NSOperation *operation in allOperations) {
        [self.operationQueue addOperation:operation];
    }
    
    return;
}

#pragma mark - HELP 辅助方法

- (NSOperation * _Nullable)operationTaskWithEvents:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context {
    
    NSURLSessionDataTask *task = [self urlRrequestWithEvents:events withContext:context];
    if (!task) {
        return nil;
    }

    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [task resume];
    }];

    return operation;
}


- (NSURLSessionDataTask * _Nullable)urlRrequestWithEvents:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context {

    NSURLRequest *request =  [self configRequestWithEvents:events withContext:context];

    if(!request) {
        return nil;
    }

    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;

        if (error == nil && httpRes.statusCode == 201) {
            HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];
            [manager asyncDeleteNamedEvents:events withCompetion:^(BOOL isSuccess) {
                if (!isSuccess) {
                    return;
                }
                
                [manager asyncRefreshContext:context withCompetion:nil];
            }];
        }

        // 客户端错误
        if (httpRes.statusCode >= 400 && httpRes.statusCode < 500) {
            HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
            record.eventID = @"HM.Statistic.Named.Internal.Exception";
            record.stringValue = [NSString stringWithFormat:@"实名统计上传内部错误"];
            record.doubleValue = nil;
            record.eventType = kHMStatisticsExceptionModule;
            record.huamiID = self.config.huamiID;

            HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];
            [manager asyncAddNamedEvent:record withCompetion:nil];
        }

        // 服务端错误
        if (httpRes.statusCode >= 500 && httpRes.statusCode < 600) {
            HMStatisticsNamedRecord *record = [[HMStatisticsNamedRecord alloc] init];
            record.eventID = @"HM.Statistic.Named.Server.Exception";
            record.stringValue = [NSString stringWithFormat:@"实名统计上传服务器错误"];
            record.doubleValue = nil;
            record.eventType = kHMStatisticsExceptionModule;
            record.huamiID = self.config.huamiID;
            
            HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];
            [manager asyncAddNamedEvent:record withCompetion:nil];
        }

        // 设置流量消耗
        double totalTraffic = [[NSUserDefaults standardUserDefaults] doubleForKey:kNamedTotalTraffic];

        double sessionTraffic = [request.HTTPBody length] /(1024.0*1024.0);

        if (data) {
            sessionTraffic += [data length] /(1024.0*1024.0);
        }

        [[NSUserDefaults standardUserDefaults] setDouble:totalTraffic forKey:kNamedTotalTraffic];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];

    return task;
}


/**
 配置请求信息

 @param events 待上传事件信息
 @return 配置完成的请求
 */
- (NSURLRequest *)configRequestWithEvents:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context{
    NSDictionary *bodyDic = [self configRequestBodyInfoWithEvents:events withContext:context];

    NSString *bodyStr = [HMStatisticsTools convertDicToJSONStr:bodyDic];
    NSAssert(bodyStr != nil, @"bodyStr is nil");
    if (!bodyStr) {
        return  nil;
    }

    NSString *encryptContent = [HMStatisticsTools generatePBKDF2Content:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSAssert(encryptContent != nil, @"encryptBody is nil");
    if (!encryptContent) {
        return  nil;
    }
    
    NSURL *url = [NSURL URLWithString:namedUploadURL];
    if (_config.isDebug) {
        url = [NSURL URLWithString:namedDubugUploadURL];
    }

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 压缩
    NSString *bodyBase64String = [HMStatisticsTools base64EncodedStringWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *gzipData = [HMStatisticsTools gzippedData:[bodyBase64String dataUsingEncoding:NSUTF8StringEncoding]];
    if (!gzipData) {
        return  nil;
    }
    request.HTTPBody = gzipData;

    [request addValue:_config.appID forHTTPHeaderField:@"appid"];
    [request addValue:encryptContent forHTTPHeaderField:@"encrypt"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];

    return request;
}


/**
 配置请求的 Body 体参数

 @return 请求的 Body 体参数
 */
- (NSDictionary *)configRequestBodyInfoWithEvents:(NSArray<HMStatisticsNamedRecord *> *)events withContext:(HMStatisticsNamedContextRecord *)context {
    NSMutableArray *eventsParams = [NSMutableArray array];
    for (HMStatisticsNamedRecord *record in events) {

        NSString *eventID = [HMStatisticsTools convertToSafeString:record.eventID];
        NSString *eventTimeZone = [HMStatisticsTools convertToSafeString:record.eventTimeZone];
        NSString *stringValue = [HMStatisticsTools convertToSafeString:record.stringValue];
        NSString *eventType = [HMStatisticsTools convertToSafeString:record.eventType];

        NSNumber *safeDouble = @(0);
        if (record.doubleValue) {
            safeDouble = record.doubleValue;
        }

        NSMutableDictionary *eventDic = [@{@"ei":eventID,
                                           @"et":@(record.eventTimestamp),
                                           @"etz":eventTimeZone,
                                           @"etp":eventType} mutableCopy];

        // 计数事件
        if ([eventType isEqualToString:kHMStatisticsCountingModule]) {
            [eventDic setObject:stringValue forKey:@"es"];
        }

        // 计算事件
        if ([eventType isEqualToString:kHMStatisticsCalculationModule]) {
            [eventDic setObject:safeDouble forKey:@"ev"];
        }

        // 异常事件
        if ([eventType isEqualToString:kHMStatisticsExceptionModule]) {
            [eventDic setObject:stringValue forKey:@"es"];
        }
        
        // 内部事件
        if ([eventType isEqualToString:kHMStatisticsInnerModule]) {
            [eventDic setObject:safeDouble forKey:@"ev"];
            [eventDic setObject:stringValue forKey:@"es"];
        }

        // 异常事件
        if ([eventType isEqualToString:kHMStatisticsExceptionModule]) {
            [eventDic setObject:stringValue forKey:@"es"];
        }

        NSString *eventParams = [HMStatisticsTools convertToSafeString:record.eventParams];

        if (![eventParams isEqualToString:@""]) {
            NSDictionary *eventParamsDic = [HMStatisticsTools convertJSONStrToDic:eventParams];
            [eventDic setObject:eventParamsDic forKey:@"ep"];
        }

        [eventsParams addObject:eventDic];
    }

    NSDictionary *clientDic = [self configRequestClientInfoWithContext:context];
    return @{@"c":clientDic,
             @"e":eventsParams};
}

/**
 配置客户端通用参数信息

 @return 获取客户端通用参数信息
 */
- (NSDictionary *)configRequestClientInfoWithContext:(HMStatisticsNamedContextRecord *)context {
    // Body
    NSMutableDictionary *clientDic = [[NSMutableDictionary alloc] init];

    // 安装包名
    [clientDic setObject:context.bundleIdentifier forKey:@"pkg"];
    
    // 设备名
    [clientDic setObject:context.deviceName forKey:@"dn"];
    
    // 华米 ID
    [clientDic setObject:context.hmID forKey:@"hmid"];
    
    //系统版本
    [clientDic setObject:context.sysVersion forKey:@"osv"];
    
    // App 版本
    [clientDic setObject:context.appVersion forKey:@"appv"];
    
    // 本地化信息
    [clientDic setObject:context.localeIdentifier forKey:@"lo"];
    
    // 事件版本
    [clientDic setObject:context.eventVersion forKey:@"evi"];
    
    // sdk 版本
    [clientDic setObject:context.sdkVersion forKey:@"sv"];
    
    // 网络状况
    [clientDic setObject:context.networkStatus forKey:@"ns"];
    
    // 屏幕分辨率信息
    [clientDic setObject:context.screenInfo forKey:@"ds"];
    
    // 产品渠道
    [clientDic setObject:context.appChannel forKey:@"ch"];
    
    // 平台
    [clientDic setObject:context.platform forKey:@"pf"];
    
    return clientDic;
}

// 检查网络状态
- (BOOL)checkNetStatus {
    HMStatisticsReachability *reachability   = [HMStatisticsReachability reachabilityWithHostName:@"www.apple.com"];
    HMStatisticsNetworkStatus internetStatus = [reachability currentReachabilityStatus];

    if (internetStatus == HMStatisticsNetworkNotReachable) {
        return NO;
    }

    return YES;
}

@end
