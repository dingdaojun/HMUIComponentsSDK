//  HMCrashReportService.m
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMCrashReportService.h"
#import "HMCrashInstallation.h"
#import <KSCrash/KSCrashInstallationStandard.h>
#import <KSCrash/KSCrash.h>

static NSString * const hmCrashProductionURL = @"https://api-analytics.huami.com/api/v3/app/exception/ios";
static NSString * const hmCrashDebugURL = @"https://api-analytics-test.huami.com/api/v3/app/exception/ios";

@implementation HMCrashReportService

+ (instancetype) sharedInstance {
    static HMCrashReportService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMCrashReportService alloc] init];
    });
    return sharedInstance;
}

/**
 Start crash report service
 
 @param appID appID
 @param appSecret appSecret
 @param isProduction isProduction
 */
- (void)startWith:(NSString *)appID secret:(NSString *)appSecret production:(BOOL)isProduction{
    [[HMCrashInstallation sharedInstance] install];
    
    NSString *urlString = hmCrashProductionURL;
    
    if (!isProduction) {
        urlString = hmCrashDebugURL;
    }
    
    [HMCrashInstallation sharedInstance].url = [[NSURL alloc] initWithString:urlString];
    [HMCrashInstallation sharedInstance].appID = appID;
    [HMCrashInstallation sharedInstance].secretKey = appSecret;
    
    KSCrash* handler = [KSCrash sharedInstance];
    handler.monitoring = KSCrashMonitorTypeProductionSafeMinimal;
    handler.deleteBehaviorAfterSendAll = KSCDeleteOnSucess;
    
    [[HMCrashInstallation sharedInstance] sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        
    }];
}

@end
