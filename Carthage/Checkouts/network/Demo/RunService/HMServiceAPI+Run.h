//
//  HMServiceAPI+Run.h
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/4/21.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>
#import "HMServiceApiRunProtocol.h"


@protocol HMServiceRunAPI <HMServiceAPI>


/**
 *  @brief  获取历史数据
 *
 *  @param type         通过source获取数据来源, 不能为空
 *                      run.mifit.huami.com为小米运动，run.watch.huami.com为手表
 *
 *  @param runTypes     子类的跑步类型数组
 *
 *  @param friendID     亲友ID（有值代表请求的是亲友的数据，没有代表是自己的数据）
 *
 *  @param startTime    从某个时间点开始往前的数据，如果为空时为当前时间
 *
 *  @param count        拉取summary个数, 不能为空
 *
 *  @param submotion    是否拉取混合运动中的子运动
 *
 *  @see    https://huami.sharepoint.cn/sites/irun/_layouts/15/WopiFrame.aspx?sourcedoc=%7B1D1280F1-1124-4F02-B447-B5C0595E6EC4%7D&file=华米运动SDK服务API文档-20160122.doc&action=default
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                    friendID:(NSString *)friendID
                                   startTime:(NSDate *)startTime
                                       count:(NSInteger)count
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock;

/**
 *  @brief  获取历史数据
 *
 *  @param type         通过sourceType获取数据来源
 *
 *  @param runTypes     子类的跑步类型数组
 *
 *  @param friendID     亲友ID（有值代表请求的是亲友的数据，没有代表是自己的数据）
 *
 *  @param startTime    从某个时间点开始往前的数据，不能为空
 *
 *  @param endTime      拉取到这个时间点的数据，不能为空
 *
 *  @param submotion    是否拉取混合运动中的子运动
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                    friendID:(NSString *)friendID
                                   startTime:(NSDate *)startTime
                                     endTime:(NSDate *)endTime
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock;

/**
 *  @brief  获取历史数据
 *
 *  @param type         通过sourceType获取数据来源
 *
 *  @param runTypes     子类的跑步类型数组
 *
 *  @param startTime    从某个时间点开始往后的数据，不能为空. 最小时间 2016-1-1
 *
 *  @param endTime      拉取到这个时间点的数据，不能为空. 最大时间 当前
 *
 *  @param submotion    是否拉取混合运动中的子运动
 *
 *  @ower   朱立挺
 */
- (id<HMCancelableAPI>)run_historyWithSource:(HMServiceAPIRunSourceType)type
                                    runTypes:(NSArray<NSNumber *> *)runTypes
                                   startTime:(NSDate *)startTime
                                     endTime:(NSDate *)endTime
                                       count:(NSInteger)count
                                   submotion:(BOOL)submotion
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock;

/**
 *  @brief  上传summary数据
 *
 *  @param  summaryItem     跑步中summary数据
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_uploadSummaryData:(id<HMServiceAPIRunSummaryData>)summaryItem
                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  更新summary数据
 *
 *  @param  trackID         跑步唯一标识符
 *
 *  @param  distance        跑步距离
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_updateSummaryWithType:(HMServiceAPIRunSourceType)type
                                         trackID:(NSString *)trackID
                                        distance:(NSInteger)distance
                                            pace:(double)pace
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  删除summary数据
 *
 *  @param  summaryItem     跑步中summary数据
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_deleteSummaryData:(id<HMServiceAPIRunSummaryData>)summaryItem
                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  删除summary数据
 *
 *  @param  trackID         跑步数据的唯一标识符
 *
 *  @param  type            通过sourceType获取数据来源
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_deleteSummaryTrackID:(NSString *)trackID
                                           type:(HMServiceAPIRunSourceType)type
                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  获取detail数据
 *
 *  @param type         通过sourceType获取数据来源
 *
 *  @param trackid      跑步数据的唯一识别符
 *
 *  @param friendID     亲友ID（有值代表请求的是亲友的数据，没有代表是自己的数据）
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_detailWithType:(HMServiceAPIRunSourceType)type
                                  trackid:(NSInteger)trackid
                                 friendID:(NSString *)friendID
                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIRunDetailData> runDetail))completionBlock;

/**
 *  @brief  上传detail数据
 *
 *  @param datailItem   跑步中详情数据
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_uploadDetailData:(id<HMServiceAPIRunDetailData>)datailItem
                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  上传config数据
 *
 *  @param  configItem  跑步Config设置信息
 *
 *  @param  type        通过sourceType获取数据来源
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_uploadConfigData:(id<HMServiceAPIRunConfigData>)configItem
                                       type:(HMServiceAPIRunSourceType)type
                            completionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *runConfig))completionBlock;

/**
 *  @brief  拉取config数据
 *
 *  @param  type         通过sourceType获取数据来源
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)run_configWithType:(HMServiceAPIRunSourceType)type
                          completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIRunConfigData> runConfig))completionBlock;

/**
*  @brief  拉取stat数据
*
*  @param  type         通过sourceType获取数据来源
*
*  @param  friendID     亲友ID（有值代表请求的是亲友的数据，没有代表是自己的数据）
*
*  @ower   单军龙
*/
- (id<HMCancelableAPI>)run_statWithType:(HMServiceAPIRunSourceType)type
                               friendID:(NSString *)friendID
                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunStatData>> *runStats))completionBlock;


@end


@interface HMServiceAPI (Run) <HMServiceRunAPI>
@end
