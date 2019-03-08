//  HMServiceAPI+FirstBeat.m
//  Created on 2017/12/29
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+FirstBeat.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

typedef NS_ENUM(NSUInteger, HMServiceAPISportStatisticsType) {
    HMServiceAPISportStatisticsTypeVO2MAX,                      // 获取的是vo2max 的数据信息
    HMServiceAPISportStatisticsTypeSportLoad,                   // 运动负荷的信息
    HMServiceAPISportStatisticsTypeNewestFirstBeat,             // firstBeat用户配置信息
};

@interface NSDictionary (HMServiceAPIVO2MAX) <HMServiceAPIVO2MAXData>
@end

@implementation NSDictionary (HMServiceAPIVO2MAXData)

- (NSDate *)api_VO2MAXDate {
    return [self.hmjson[@"dayId"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSDate *)api_VO2MAXDataUpdateTime {
    return self.hmjson[@"update_time"].date;
}


- (double)api_VO2MAXDataVO2MaxRun {
    return self.hmjson[@"vo2_max_run"].doubleValue;
}

- (double)api_VO2MAXDataVO2MaxWalking {
    return self.hmjson[@"vo2_max_walking"].doubleValue;
}

@end

@interface NSDictionary (HMServiceAPISportLoadData) <HMServiceAPISportLoadData>
@end

@implementation NSDictionary (HMServiceAPISportLoadData)

- (NSDate *)api_sportLoadDate {
    return [self.hmjson[@"dayId"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSDate *)api_sportLoadUpdateTime {
    return self.hmjson[@"updateTime"].date;
}

- (NSInteger)api_sportLoadWtlSum {
    return self.hmjson[@"wtlSum"].integerValue;
}

- (NSInteger)api_sportLoadCurrnetDayTrainLoad {
    return self.hmjson[@"currnetDayTrainLoad"].integerValue;
}

- (NSInteger)api_sportLoadWtlSumOptimalMax {
    return self.hmjson[@"wtlSumOptimalMax"].integerValue;
}

- (NSInteger)api_sportLoadWtlSumOverreaching {
    return self.hmjson[@"wtlSumOverreaching"].integerValue;
}

- (NSInteger)api_sportLoadWtlSumOptimalMin {
    return self.hmjson[@"wtlSumOptimalMin"].integerValue;
}

@end


static NSString *stringWithStatisticsType(HMServiceAPISportStatisticsType type) {
    switch (type) {
        case HMServiceAPISportStatisticsTypeVO2MAX:
            return @"VO2_MAX";
        case HMServiceAPISportStatisticsTypeSportLoad:
            return @"SPORT_LOAD";
        case HMServiceAPISportStatisticsTypeNewestFirstBeat:
            return @"Newest_firstBeat_data";
        default:
            NSCAssert(NO, @"Impossible!");
    }
    return @"";
}


@implementation HMServiceAPI (FirstBeat)

- (id<HMCancelableAPI>)firstBeat_VO2MAXDataWithStartDate:(NSDate *)startDate
                                                 endDate:(NSDate *)endDate
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIVO2MAXData>> *vo2MAXDatas))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [self firstBeat_dataWithStartDate:startDate
                                     endDate:endDate
                                        type:HMServiceAPISportStatisticsTypeVO2MAX
                             completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)firstBeat_sportLoadDataWithStartDate:(NSDate *)startDate
                                                    endDate:(NSDate *)endDate
                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISportLoadData>> *sportLoadDatas))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    return [self firstBeat_dataWithStartDate:startDate
                                     endDate:endDate
                                        type:HMServiceAPISportStatisticsTypeSportLoad
                             completionBlock:completionBlock];
}

- (id<HMCancelableAPI>)firstBeat_dataWithStartDate:(NSDate *)startDate
                                           endDate:(NSDate *)endDate
                                              type:(HMServiceAPISportStatisticsType)type
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSArray *items))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(NO, @"账号已经退出", nil);
        });
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *typeString = stringWithStatisticsType(type);
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:[NSString stringWithFormat:@"watch/users/%@/WatchSportStatistics/%@", userID, typeString]];

        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }

        NSDateFormatter *dateFormatter  = [NSDateFormatter new];
        dateFormatter.dateFormat        = @"yyyy-MM-dd";

        NSString *startDateString = [dateFormatter stringFromDate:startDate];
        NSString *endDateString = [dateFormatter stringFromDate:endDate];
        NSMutableDictionary *parameters = [@{@"startDay" : startDateString,
                                             @"endDay" : endDateString} mutableCopy];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                                   NSArray *items = data.hmjson[@"items"].array;
                                   completionBlock(success, message, items);
                               }];
                  }];
    }];
}


@end
