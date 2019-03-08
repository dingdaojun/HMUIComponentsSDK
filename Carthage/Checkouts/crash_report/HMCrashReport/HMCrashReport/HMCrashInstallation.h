//  HMCrashInstallation.h
//  Created on 2018/6/19
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashInstallation.h>

@interface HMCrashInstallation : KSCrashInstallation

/** The URL to connect to. */
@property(nonatomic, copy) NSURL* url;

@property(nonatomic, copy) NSString *appID;

@property(nonatomic, copy) NSString *secretKey;

+ (instancetype) sharedInstance;

@end
