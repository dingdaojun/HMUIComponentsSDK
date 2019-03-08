//
//  HMServiceAPI+UserDataRank.h
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceUserDataRankAPI <HMServiceAPI>

/**
 步数数据日排名
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=72
 */
- (id<HMCancelableAPI>)userDataRank_stepRankInDay:(NSDate *)day
                                        stepCount:(NSUInteger)stepCount
                                  completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock;

/**
 睡眠数据日排名
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=72
 */
- (id<HMCancelableAPI>)userDataRank_sleepRankInDay:(NSDate *)day
                                sleepTimeInMinutes:(NSUInteger)minutes
                                  completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock;

/**
 目标达标时间排名
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=72
 */
- (id<HMCancelableAPI>)userDataRank_goalAchievementRankInDay:(NSDate *)day
                                                achievedDays:(NSUInteger)days
                                             completionBlock:(void (^)(BOOL success, NSString *message, double beatPercentage))completionBlock;
 

@end

@interface HMServiceAPI (UserDataRank) <HMServiceUserDataRankAPI>
@end
