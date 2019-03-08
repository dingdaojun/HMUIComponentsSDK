//  HMServiceAPI+FirstBeat.h
//  Created on 2017/12/29
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>




@protocol HMServiceAPIVO2MAXData <NSObject>

@property (readonly) NSDate      *api_VO2MAXDate;                   // 数据的时间（精确到天）
@property (readonly) NSDate      *api_VO2MAXDataUpdateTime;         // 数据更新的时间
@property (readonly) double      api_VO2MAXDataVO2MaxRun;           // 当天的跑步的vo2max float
@property (readonly) double      api_VO2MAXDataVO2MaxWalking;       // 当天的健走的vo2max float

@end

@protocol HMServiceAPISportLoadData <NSObject>

@property (readonly) NSDate      *api_sportLoadDate;                 // 数据的时间（精确到天）
@property (readonly) NSInteger   api_sportLoadWtlSum;                // 七天的运动负荷
@property (readonly) NSInteger   api_sportLoadCurrnetDayTrainLoad;    // 当天的运动负荷 int
@property (readonly) NSDate      *api_sportLoadUpdateTime;           // 数据更新的时间
@property (readonly) NSInteger   api_sportLoadWtlSumOptimalMax;      // 绘制运动负荷曲线的最大标线
@property (readonly) NSInteger   api_sportLoadWtlSumOverreaching;    // 制运动负荷曲线的Overreach标线 int
@property (readonly) NSInteger   api_sportLoadWtlSumOptimalMin;      // 绘制运动负荷曲线的最小标线 int

@end

@protocol HMServiceFirstBeatAPI <HMServiceAPI>

/**
 *  @brief  获取最大摄氧量的数据
 *
 *  @param  startDate       拉取数据的开始时间
 *
 *  @param  endDate         拉取数据的结束时间
 *
 *  @param completionBlock  回调方法
 *
 *  @see    http://watch-staging.private.mi-ae.net/swagger-ui.html#!/watch45sport45statistics45controller/listVO2MaxUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)firstBeat_VO2MAXDataWithStartDate:(NSDate *)startDate
                                                 endDate:(NSDate *)endDate
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIVO2MAXData>> *vo2MAXDatas))completionBlock;

/**
 *  @brief  获取运动适能的数据
 *
 *  @param  startDate       拉取数据的开始时间
 *
 *  @param  endDate         拉取数据的结束时间
 *
 *  @param completionBlock  回调方法
 *
 *  @see    http://watch-staging.private.mi-ae.net/swagger-ui.html#!/watch45sport45statistics45controller/listVO2MaxUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)firstBeat_sportLoadDataWithStartDate:(NSDate *)startDate
                                                    endDate:(NSDate *)endDate
                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISportLoadData>> *sportLoadDatas))completionBlock;

@end


@interface HMServiceAPI (FirstBeat) <HMServiceFirstBeatAPI>

@end
