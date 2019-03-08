//
//  HMServiceAPI+AmazifitWatchRun.m
//  AmazfitWatch
//
//  Created by 朱立挺 on 2017/10/31.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+AmazfitWatchRun.h"

@implementation HMServiceAPI (AmazifitWatchRun)

// 运动历史列表
- (void)run_historyWithRunTypes:(NSArray <NSNumber *>*)runTypes
                        sources:(NSArray <NSNumber *>*)sources
                          dates:(NSArray <NSDate *>*)dates
                completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys)) completionBlock {
    
    NSDate *currentDate = [NSDate date];

    [self sportItemListWithSource:sources
                     currentIndex:0
                            array:nil
                     originalTimes:dates
                        startTime:dates[0]
                          endTime:currentDate
                         runTypes:runTypes
                  completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys) {
                      
                      if (!completionBlock) {
                          return;
                      }
                      
                      if (!success) {
                          completionBlock(NO, message, nil);
                          return;
                      }
                      
                      completionBlock(YES, message, runSummarys);
                      
                  }];
    
}

#pragma mark -- actions

//originalTime 是请求数据源的起始时间,startTime 是同个数据源的分页时间. 当不分页的时候,此值相同

- (void)sportItemListWithSource:(NSArray <NSNumber *>*)source
                    currentIndex:(NSInteger)index
                           array:(NSMutableArray *)array
                   originalTimes:(NSArray <NSDate *>*)originalTimes
                       startTime:(NSDate *)startTime
                         endTime:(NSDate *)endTime
                        runTypes:(NSArray <NSNumber *>*)runTypes
                 completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    
    NSParameterAssert(source.count > 0);
    
    if (!array) {
        array = [NSMutableArray new];
    }
    
    if ([startTime timeIntervalSinceDate:endTime] > 0) {
        completionBlock(NO, @"当前时间不正确", nil);
        return;
    }
    
    [[self run_historyWithSource:[source[index]integerValue]
                        runTypes:runTypes
                       startTime:startTime
                         endTime:endTime
                           count:1000
                       submotion:YES
                 completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys) {
        
        if (!success) {
            completionBlock(NO, message, array);
            return;
        }
                                               
        if (runSummarys) {
            [array addObjectsFromArray:runSummarys];
        }
                                               
        if (runSummarys.count >= 1000) {
          id <HMServiceAPIRunSummaryData> summary = [runSummarys lastObject];
            
            [self sportItemListWithSource:source
                             currentIndex:index
                                    array:array
                            originalTimes:originalTimes
                                startTime:summary.api_runStartTime
                                  endTime:endTime
                                 runTypes:runTypes
                          completionBlock:completionBlock];
            return;
        }
        
        if (index + 1 == source.count) {
            completionBlock(YES, nil, array);
            return;
        }
        
        [self sportItemListWithSource:source
                         currentIndex:index+1
                                array:array
                        originalTimes:originalTimes
                            startTime:originalTimes[index+1]
                              endTime:endTime
                             runTypes:runTypes
                      completionBlock:completionBlock];
        
    }] printCURL];
    
}

@end

