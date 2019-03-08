//
//  HMServiceAPI+AmazifitWatchRun.h
//  AmazfitWatch
//
//  Created by 朱立挺 on 2017/10/31.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>
#import <RunService/RunService.h>


@interface HMServiceAPI (AmazifitWatchRun)

- (void)run_historyWithRunTypes:(NSArray <NSNumber *>*)runTypes
                        sources:(NSArray <NSNumber *>*)sources
                          dates:(NSArray <NSDate *>*)dates
                completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys)) completionBlock;

@end
