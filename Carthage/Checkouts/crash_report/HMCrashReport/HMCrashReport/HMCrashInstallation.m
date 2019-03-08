//  HMCrashInstallation.m
//  Created on 2018/6/19
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMCrashInstallation.h"
#import "HMCrashReportSink.h"
#import <KSCrash/KSCrashInstallation+Private.h>
#import <KSCrash/KSCrashReportSinkStandard.h>
#import <KSCrash/KSCrashReportFilterBasic.h>

@implementation HMCrashInstallation

+ (instancetype) sharedInstance {
    static HMCrashInstallation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMCrashInstallation alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    return [super initWithRequiredProperties:[NSArray arrayWithObjects:@"url", nil]];
}

- (id<KSCrashReportFilter>) sink {
    HMCrashReportSink* sink = [HMCrashReportSink sinkWithURL:self.url];
    sink.appID = self.appID;
    sink.secretKey = self.secretKey;
    
    return [KSCrashReportFilterPipeline filterWithFilters:[sink defaultCrashReportFilterSet], nil];
}

@end
