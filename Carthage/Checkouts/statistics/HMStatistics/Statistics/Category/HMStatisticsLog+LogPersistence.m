//
//  HMStatisticsLog+LogPersistence.m
//  HMStatistics
//
//  Created by 吴明亮 on 2018/5/23.
//

#import "HMStatisticsLog+LogPersistence.h"
#import "HMStatisticsAnonymousTask.h"
#import "HMStatisticsNamedTask.h"
#import "HMStatisticsAnonymousManager.h"
#import "HMStatisticsAnonymousRecord.h"
#import "HMStatisticsAnonymousContextRecord.h"
#import "HMStatisticsNamedManager.h"
#import "HMStatisticsNamedRecord.h"
#import "HMStatisticsNamedContextRecord.h"
#import "HMStatisticsTools.h"
#import "HMStatisticsReachability.h"
#import "HMStatisticsTools+DeviceInfo.h"
#import "HMStatisticsDefine.h"

@implementation HMStatisticsLog (LogPersistence)

#pragma mark - Log Persistence
/**
 匿名统计数据持久化

 @param record 匿名统计数据
 */
+ (void)anonymousEventPersistence:(HMStatisticsAnonymousRecord *)record {

    // 如果为开启服务则不进行后续操作
    if (![HMStatisticsAnonymousTask sharedInstance].isServiceStart) {
        return;
    }

    HMStatisticsAnonymousManager *manager = [[HMStatisticsAnonymousManager alloc] init];

    HMStatisticsAnonymousContextRecord *currentContext = [HMStatisticsLog getCurrentAnonymousContex];
    [manager asyncAddContext:currentContext withCompetion:^(BOOL isSuccess, NSNumber * _Nonnull contextID) {
        
        if (!isSuccess || !contextID) {
            return;
        }
        
        record.contextID = contextID;
        
        [manager asyncAddAnonymousEvent:record withCompetion:^(BOOL isSuccess) {
            if (!isSuccess) {
                return;
            }
            
            [[HMStatisticsAnonymousTask sharedInstance] processRealTimeEventLog:@[record] withContext:currentContext];
        }];
    }];
}

/**
 实名统计数据持久化

 @param record 实名统计数据
 */
+ (void)namedEventPersistence:(HMStatisticsNamedRecord *)record {

    // 如果为开启服务则不进行后续操作
    if (![HMStatisticsNamedTask sharedInstance].isServiceStart) {
        return;
    }

    HMStatisticsNamedManager *manager = [[HMStatisticsNamedManager alloc] init];

    HMStatisticsNamedContextRecord *currentContext = [HMStatisticsLog getCurrentnamedContex];
    
    [manager asyncAddContext:currentContext withCompetion:^(BOOL isSuccess, NSNumber * _Nullable contextID) {
        if (!isSuccess || !contextID) {
            return;
        }
        
        record.contextID = contextID;
        
        [manager asyncAddNamedEvent:record withCompetion:^(BOOL isSuccess) {
            if (!isSuccess) {
                return;
            }
            
            [[HMStatisticsNamedTask sharedInstance] processRealTimeEventLog:@[record] withContext:currentContext];
        }];
    }];
}

# pragma mark - Context Helper
+ (HMStatisticsAnonymousContextRecord *)getCurrentAnonymousContex {
    HMStatisticsAnonymousContextRecord *context = [[HMStatisticsAnonymousContextRecord alloc] init];
   
    // 安装包名
    context.bundleIdentifier = [HMStatisticsTools convertToSafeString:[[NSBundle mainBundle] bundleIdentifier]];

    // 设备名
    context.deviceName = [HMStatisticsTools getDeviceName];
    
    //系统版本
    context.sysVersion = [HMStatisticsTools convertToSafeString:[[UIDevice currentDevice] systemVersion]];
   
    // App 版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    context.appVersion = [HMStatisticsTools convertToSafeString:appVersion];
    
    // 本地化信息
    context.localeIdentifier = [HMStatisticsTools convertToSafeString:[NSLocale currentLocale].localeIdentifier];
    
    // 设备 ID
    NSString *app_uuid = @"";
    if ([[UIDevice currentDevice] identifierForVendor] != nil) {
        app_uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        app_uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    context.uuid = [HMStatisticsTools convertToSafeString:app_uuid];

    // 事件版本
    context.eventVersion = kHMStatisticsEventVersion;
   
    // sdk 版本
    context.sdkVersion = kHMStatisticsSDKVersion;
    
    // 网络状况
    context.networkStatus = [HMStatisticsReachability internetStatus];
    
    // 屏幕分辨率信息
    NSInteger   width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    NSInteger   height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    context.screenInfo = [NSString stringWithFormat:@"%ld * %ld",(long)width,(long)height];
    
    // 产品渠道
    context.appChannel = [[HMStatisticsAnonymousTask sharedInstance] configChannelID];
    
    // 平台
    context.platform = @"iOS";
    
    return context;
}

+ (HMStatisticsNamedContextRecord *)getCurrentnamedContex {
    HMStatisticsNamedContextRecord *context = [[HMStatisticsNamedContextRecord alloc] init];
    
    // 安装包名
    context.bundleIdentifier = [HMStatisticsTools convertToSafeString:[[NSBundle mainBundle] bundleIdentifier]];
    
    // 设备名
    context.deviceName = [HMStatisticsTools getDeviceName];
    
    context.hmID = [[HMStatisticsNamedTask sharedInstance] configUserID];
    //系统版本
    context.sysVersion = [HMStatisticsTools convertToSafeString:[[UIDevice currentDevice] systemVersion]];
    
    // App 版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    context.appVersion = [HMStatisticsTools convertToSafeString:appVersion];
    
    // 本地化信息
    context.localeIdentifier = [HMStatisticsTools convertToSafeString:[NSLocale currentLocale].localeIdentifier];
    
    // 事件版本
    context.eventVersion = kHMStatisticsEventVersion;
    
    // sdk 版本
    context.sdkVersion = kHMStatisticsSDKVersion;
    
    // 网络状况
    context.networkStatus = [HMStatisticsReachability internetStatus];
    
    // 屏幕分辨率信息
    NSInteger   width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    NSInteger   height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    context.screenInfo = [NSString stringWithFormat:@"%ld * %ld",(long)width,(long)height];
    
    // 产品渠道
    context.appChannel = [[HMStatisticsNamedTask sharedInstance] configChannelID];
    
    // 平台
    context.platform = @"iOS";
    
    return context;
}



@end
