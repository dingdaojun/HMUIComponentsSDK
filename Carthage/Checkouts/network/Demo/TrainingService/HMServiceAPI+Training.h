//
//  HMServiceAPI+Training.h
//  HMNetworkLayer
//
//  Created by 李宪 on 22/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"
#import "HMServiceAPITrainingTypeDefine.h"
#import "HMServiceAPITrainingArticle.h"
#import "HMServiceAPITrainingData.h"
#import "HMServiceAPITrainingRecord.h"
#import "HMServiceAPITrainingCollection.h"
#import "HMServiceAPITrainingPlan.h"
#import "HMServiceAPITrainingBanner.h"
#import "HMServiceAPITrainingKnowledge.h"
#import "HMServiceAPITrainingMiDongQuan.h"


@protocol HMServiceTrainingAPI <HMServiceAPI>

/**
 获取用户的训练列表
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.1
 @see http://hefei.huami.com:8005/static/index.html# 获取用户的自由训练列表
 @param gender 用户性别，必传
 */
- (id<HMCancelableAPI>)training_userTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock;

/**
 获取训练课程详情
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.3
 @see http://hefei.huami.com:8005/static/index.html# 获取某个训练课程详情
 @param gender 用户性别，必传
 */
- (id<HMCancelableAPI>)training_trainingPlanWithGender:(HMServiceAPITrainingUserGender)gender
                                       completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingPlan>trainingPlan))completionBlock;

/**
 获取推荐训练
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.5
 @see http://hefei.huami.com:8005/static/index.html# 获取推荐训练
 @param gender 用户性别，必传
 @param BMIType BMI类型，必传
 */
- (id<HMCancelableAPI>)training_recommendedTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                                       BMIType:(HMServiceAPITrainingBMIType)BMIType
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock;

/**
 获取推荐文章
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.6
 @see http://hefei.huami.com:8005/static/index.html# 获取推荐文章
 @param gender 用户性别，必传
 @param BMIType BMI类型，必传
 */
- (id<HMCancelableAPI>)training_recommendedArticlesWithGender:(HMServiceAPITrainingUserGender)gender
                                                      BMIType:(HMServiceAPITrainingBMIType)BMIType
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingArticle>> *articles))completionBlock;

/**
 获取轮播图
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.7
 @see http://hefei.huami.com:8005/static/index.html# 获取轮播训练
 @param gender 用户性别，必传
 @param BMIType BMI类型，必传
 */
- (id<HMCancelableAPI>)training_bannersWithUserGender:(HMServiceAPITrainingUserGender)gender
                                              BMIType:(HMServiceAPITrainingBMIType)BMIType
                                      completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingBanner>> *banners))completionBlock;

/**
 获取人气训练
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.8
 @see http://hefei.huami.com:8005/static/index.html# 获取人气训练
 @param gender 用户性别，必传
 @param BMIType BMI类型，必传
 */
- (id<HMCancelableAPI>)training_popularTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                                   BMIType:(HMServiceAPITrainingBMIType)BMIType
                                           completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock;

/**
 获取全部训练
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.9
 @see http://hefei.huami.com:8005/static/index.html# 获取全部训练
 @param gender 性别，必传
 @param difficulty 难度，非必传。HMServiceAPITrainingDifficultyAny表示忽略
 @param bodyPart 身体部位，非必传。如果nil曾此项忽略
 @param instrument 器械，非必传。如果nil曾此项忽略
 @param lastTrainingData 本地最后一项纪录，非必传。nil即为下拉刷新，非nil为上拉加载更多
 */
- (id<HMCancelableAPI>)training_allTrainingsWithGender:(HMServiceAPITrainingUserGender)gender
                                            difficulty:(HMServiceAPITrainingDifficulty)difficulty
                                              bodyPart:(id<HMServiceAPITrainingBodyPart>)bodyPart
                                            instrument:(id<HMServiceAPITrainingInstrument>)instrument
                                      lastTrainingData:(id<HMServiceAPITrainingData>)lastTrainingData
                                       completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock;

/**
 获取训练专题列表
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.10
 @see http://hefei.huami.com:8005/static/index.html# 获取训练专题列表
 @param gender 性别，必传
 @param BMIType BMI类型，必传
 */
- (id<HMCancelableAPI>)training_trainingCollectionsWithGender:(HMServiceAPITrainingUserGender)gender
                                                      BMIType:(HMServiceAPITrainingBMIType)BMIType
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingCollection>> *trainingCollections))completionBlock;

/**
 获取训练详情
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.12
 @see http://hefei.huami.com:8005/static/index.html# 获取训练详情
 @param trainingID 训练ID，必传
 @param gender 用户性别，必传
 */
- (id<HMCancelableAPI>)training_trainingDetailWithID:(NSString *)trainingID
                                              gender:(HMServiceAPITrainingUserGender)gender
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingData>trainingData))completionBlock;

/**
 用户添加自由训练
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.13
 @see http://hefei.huami.com:8005/static/index.html# 用户添加自由训练
 @param trainingID 训练ID，必传
 */
- (id<HMCancelableAPI>)training_joinTrainingWithID:(NSString *)trainingID
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 记录训练完成状态
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.15
 @see http://hefei.huami.com:8005/static/index.html# 记录训练完成状态
 @param trainingID 训练ID，必传
 @param trainingPlanID 训练计划ID，非必传
 @param beginTime 开始时机，必传
 @param endTime 结束时间，必传
 @param duration 用户运动时间，必传
 @param heartRates 心率数组，非必传
 */
- (id<HMCancelableAPI>)training_uploadRecordWithTrainingID:(NSString *)trainingID
                                            trainingPlanID:(NSString *)trainingPlanID
                                                 beginTime:(NSDate *)beginTime
                                                   endTime:(NSDate *)endTime
                                                  duration:(NSTimeInterval)duration
                                                heartRates:(NSArray<id<HMServiceAPITrainingRecordHeartRate>> *)heartRates
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 用户退出自由训练
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.16
 @see http://hefei.huami.com:8005/static/index.html# 退出自由训练
 @param trainingID 训练ID，必传
 */
- (id<HMCancelableAPI>)training_quitTrainingWithID:(NSString *)trainingID
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 创建训练课程
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.17
 @see http://hefei.huami.com:8005/static/index.html# 添加训练课程
 @param function 训练功能，必传
 @param difficulty 难度，必传
 @param gender 用户性别，必传
 @param date 日期，必传
 */
- (id<HMCancelableAPI>)training_createTrainingPlanWithFunction:(HMServiceAPITrainingFunctionType)function
                                                difficulty:(HMServiceAPITrainingDifficulty)difficulty
                                                    gender:(HMServiceAPITrainingUserGender)gender
                                                      date:(NSDate *)date
                                               completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingPlan>trainingPlan))completionBlock;

/**
 用户退出训练课程
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.18
 @param trainingPlanID 训练课程ID，必传
 */
- (id<HMCancelableAPI>)training_quitTrainingPlanWithID:(NSString *)trainingPlanID
                                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取训练历史记录
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.19
 @see http://hefei.huami.com:8005/static/index.html# 获取训练历史记录
 @param beginTime 开始时间，nil则表示从最早的数据开始
 @param endTime 结束时间，nil则表示到最新的数据
 @param gender 用户性别，必传
 
 @result totalTimeSpent 总时间消耗
 @result totalFinishedCount 总完成次数
 @result totalEnergyBurnedInCalorie 总消耗卡路里
 */
- (id<HMCancelableAPI>)training_trainingRecordsFromTime:(NSDate *)beginTime
                                                 toTime:(NSDate *)endTime
                                                 gender:(HMServiceAPITrainingUserGender)gender
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingRecord>> *trainingRecords, NSTimeInterval totalTimeSpent, NSUInteger totalFinishedCount, double totalEnergyBurnedInCalorie))completionBlock;

/**
 获取训练知识
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.25
 @see http://hefei.huami.com:8005/static/index.html# 获取训练知识
 @param lastKnowledge 本地最后一项纪录，非必传。nil即为下拉刷新，非nil为上拉加载更多
 */
- (id<HMCancelableAPI>)training_knowledgesWithLastOne:(id<HMServiceAPITrainingKnowledge>)lastKnowledge
                                      completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingKnowledge>> *knowledges))completionBlock;

/**
 获取推荐米动圈
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.26
 @see http://hefei.huami.com:8005/static/index.html# 获取推荐的训练帖子
 */
- (id<HMCancelableAPI>)training_recommendedMiDongQuanWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingMiDongQuan>> *miDongQuans))completionBlock;

/**
 获取训练专题里的训练列表
 训练轮播图中，如果 type 是训练合集，则点击根据合集 id 获取训练列表
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.28
 @see http://hefei.huami.com:8005/static/index.html# 获取合集里的单次训练列表
 @param collectionID 训练专辑ID，必传
 @param gender 用户性别，必传
 */
- (id<HMCancelableAPI>)training_collectionTrainingsWithCollecitonID:(NSString *)collectionID
                                                             gender:(HMServiceAPITrainingUserGender)gender
                                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingData>> *trainingDatas))completionBlock;

/**
 获取字典项
 目前只是用了器械和身体部位两项
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.27
 @see http://hefei.huami.com:8005/static/index.html# 获取字典项
 */
- (void)training_dataItemsWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPITrainingBodyPart>> *bodyParts, NSArray<id<HMServiceAPITrainingInstrument>> *instruments))completionBlock;

/**
 获取训练历史记录详情
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.30
 @see http://hefei.huami.com:8005/static/index.html# 获取训练历史详情
 @param ID 记录ID，必传
 @param trainingID 训练ID，必传
 @param gender 用户性别，必传
 */
- (id<HMCancelableAPI>)training_trainingRecordWithID:(NSString *)ID
                                          trainingID:(NSString *)trainingID
                                              gender:(HMServiceAPITrainingUserGender)gender
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPITrainingRecord>trainingRecord))completionBlock;

/**
 参加训练课程
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.31
 @see http://hefei.huami.com:8005/static/index.html# 参加训练课程
 @param trainingPlanID 课程ID，必传
 @param date 日期，必传
 */
- (id<HMCancelableAPI>)training_jsonTrainingPlanWithID:(NSString *)trainingPlanID
                                                  date:(NSDate *)date
                                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 删除训练历史记录
 @see https://huami.sharepoint.cn/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B15E81D8E-6DB8-4436-BAAC-7A7B1D8C6470%7D 2.32
 @see http://hefei.huami.com:8005/static/index.html# 删除训练历史记录
 @param ID 记录ID，必传
 @param trainingID 训练ID，必传
 */
- (id<HMCancelableAPI>)training_deleteTrainingRecordWithID:(NSString *)ID
                                                trainingID:(NSString *)trainingID
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end

@interface HMServiceAPI (Training) <HMServiceTrainingAPI>
@end
