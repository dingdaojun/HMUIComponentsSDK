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
    
    [self sportItemListWithSources:sources
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

- (void)sportItemListWithSources:(NSArray <NSNumber *>*)sources
                    currentIndex:(NSInteger)index
                           array:(NSMutableArray *)array
                   originalTimes:(NSArray <NSDate *>*)originalTimes
                       startTime:(NSDate *)startTime
                         endTime:(NSDate *)endTime
                        runTypes:(NSArray <NSNumber *>*)runTypes
                 completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    
    NSParameterAssert(sources.count > 0);
    
    if (!array) {
        array = [NSMutableArray new];
    }
    
    if ([startTime timeIntervalSinceDate:endTime] > 0) {
        completionBlock(NO, @"当前时间不正确", nil);
        return;
    }
    
    [[self run_historyWithSource:[sources[index]integerValue]
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
                         
                         [self sportItemListWithSources:sources
                                           currentIndex:index
                                                  array:array
                                          originalTimes:originalTimes
                                              startTime:summary.api_runStartTime
                                                endTime:endTime
                                               runTypes:runTypes
                                        completionBlock:completionBlock];
                         return;
                     }
                     
                     if (index + 1 == sources.count) {
                         completionBlock(YES, nil, array);
                         return;
                     }
                     
                     [self sportItemListWithSources:sources
                                       currentIndex:index+1
                                              array:array
                                      originalTimes:originalTimes
                                          startTime:originalTimes[index+1]
                                            endTime:endTime
                                           runTypes:runTypes
                                    completionBlock:completionBlock];
                     
                 }] printCURL];
    
}

- (void)run_historyGroupWithRunTypes:(NSArray <NSNumber *>*)runTypes
                             sources:(NSArray <NSNumber *>*)sources
                               dates:(NSArray <NSDate *>*)dates
                     completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    
    if (!completionBlock) {
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    
    NSInteger minLength = MIN(sources.count, dates.count);
    
    NSMutableArray *totalRunSummarys = [NSMutableArray new];
    __block NSString *errorMessage;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < minLength; i ++) {
        
        HMServiceAPIRunSourceType sourceType = [sources[i] integerValue];
        NSDate *date = dates[i];
        
        dispatch_group_enter(group);
        [self sportItemListWithSourceType:sourceType
                                    array:nil
                                startTime:date
                                  endTime:currentDate
                                 runTypes:runTypes
                          completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys) {
                              
                              if (!success) {
                                  errorMessage = message;
                                  dispatch_group_leave(group);
                                  return;
                              }
                              
                              [totalRunSummarys addObjectsFromArray:runSummarys];
                              dispatch_group_leave(group);
                          }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (errorMessage.length > 0) {
            completionBlock(NO, errorMessage, nil);
            return;
        }
        
        completionBlock(YES, nil, totalRunSummarys);
        
    });
}

- (void)sportItemListWithSourceType:(HMServiceAPIRunSourceType )sourceType
                              array:(NSMutableArray *)array
                          startTime:(NSDate *)startTime
                            endTime:(NSDate *)endTime
                           runTypes:(NSArray <NSNumber *>*)runTypes
                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    
    if (!array) {
        array = [NSMutableArray new];
    }
    
    if ([startTime timeIntervalSinceDate:endTime] > 0) {
        completionBlock(NO, @"当前时间不正确", nil);
        return;
    }
    
    [[self run_historyWithSource:sourceType
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
                         
                         [self sportItemListWithSourceType:sourceType
                                                     array:array
                                                 startTime:summary.api_runStartTime
                                                   endTime:endTime
                                                  runTypes:runTypes
                                           completionBlock:completionBlock];
                         return;
                     }
                     
                     completionBlock(YES, nil, array);
                     return;
                     
                 }] printCURL];
}

- (void)sportItemListWithSourceType:(HMServiceAPIRunSourceType )sourceType
                          startTime:(NSDate *)startTime
                            endTime:(NSDate *)endTime
                           runTypes:(NSArray <NSNumber *>*)runTypes
                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys))completionBlock {
    
    if (!completionBlock) {
        return;
    }
    
    if ([startTime timeIntervalSinceDate:endTime] > 0) {
        completionBlock(NO, @"当前时间不正确", nil);
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    
    __block NSDate *beggingDate = startTime;
    __block BOOL stop = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        while (!stop) {
            
            [self run_historyWithSource:sourceType
                               runTypes:runTypes
                              startTime:beggingDate
                                endTime:endTime
                                  count:1000
                              submotion:YES
                        completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys) {
                            
                            if (!success) {
                                stop = YES;
                                dispatch_semaphore_signal(semaphore);
                                return;
                            }
                            
                            [array addObject:runSummarys];
                            
                            if (runSummarys.count < 1000) {
                                stop = YES;
                                
                                completionBlock(YES, nil, array);
                                dispatch_semaphore_signal(semaphore);
                                return;
                            }
                            
                            id<HMServiceAPIRunSummaryData> summary = runSummarys.lastObject;
                            beggingDate = summary.api_runStartTime;
                            
                            dispatch_semaphore_signal(semaphore);
                        }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

@end
