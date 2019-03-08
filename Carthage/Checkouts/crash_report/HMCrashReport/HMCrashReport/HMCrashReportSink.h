//  HMCrashReportSink.h
//  Created on 2018/6/19
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>
#import <KSCrash/KSCrashReportFilter.h>

@interface HMCrashReportSink : NSObject <KSCrashReportFilter>

@property(nonatomic, copy) NSString *appID;

@property(nonatomic, copy) NSString *secretKey;

/** Constructor.
 *
 * @param url The URL to connect to.
 */
+ (HMCrashReportSink*)sinkWithURL:(NSURL*) url;

/** Constructor.
 *
 * @param url The URL to connect to.
 */
- (instancetype)initWithURL:(NSURL*)url;

- (id <KSCrashReportFilter>)defaultCrashReportFilterSet;

@end
