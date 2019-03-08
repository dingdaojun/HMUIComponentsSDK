//
//  HMAppDelegate.m
//  HMStatistics
//
//  Created by BigNerdCoding on 01/11/2018.
//  Copyright (c) 2018 BigNerdCoding. All rights reserved.
//

#import "HMAppDelegate.h"
#import <HMStatistics/HMStatisticsLog.h>
#import <HMStatistics/HMStatisticsConfig.h>

static NSString *kDubegAPPID = @"E35F5F0E6D8DFAAAD33A6BC2";
static NSString *kDebugSecret = @"a5bd7a3e9dbceccb9d55163d5b7f5ba6";
static NSString *kProductionAPPID = @"CF727989B57902655FA23B06";
static NSString *kProductionSecret = @"1fa831b9631c8bad313c9ad98e320a1f";

@implementation HMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    HMStatisticsConfig *config = [[HMStatisticsConfig alloc] init];

    config.reportPolicy = HMStatisticsReportPolicySendInterval;
    config.appID = kDubegAPPID;
    config.secret = kDebugSecret;
    config.huamiID = @"01";

    [HMStatisticsLog startWithConfig:config andTypes:HMStatisticsServiceTypeNamed|HMStatisticsServiceTypeAnonymous];

    NSString* dir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ] stringByAppendingPathComponent:@"HMStatistics"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
