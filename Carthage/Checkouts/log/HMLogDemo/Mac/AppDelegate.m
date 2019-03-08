//
//  AppDelegate.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "AppDelegate.h"
#import "HMLog.h"


@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

    HMLogManager *manager       = [HMLogManager sharedInstance];

    HMConsoleLogger *console    = [HMConsoleLogger sharedLogger];
    console.filterLevels        = [NSSet setWithArray:@[@(HMLogLevelInfo), @(HMLogLevelError), @(HMLogLevelWarning)]];
//    console.filterTags          = [NSSet setWithArray:@[@"tag1"]];
    [manager addLogger:console];

    HMDatabaseLogger *db        = [HMDatabaseLogger sharedLogger];
    db.filterLevels             = [NSSet setWithArray:@[@(HMLogLevelError)]];
//    db.filterTags               = [NSSet setWithArray:@[@"tag2"]];
    db.maximumItemCount         = 10000;
    [manager addLogger:db];

    HMFileLogger *file          = [HMFileLogger sharedLogger];
    [manager addLogger:file];

    HMWebLogger *web            = [[HMWebLogger alloc] initWithPort:9999];
    [manager addLogger:web];

    [manager startup];

    [self test];
//    [self batchTest];
    [self dataTest];
}

- (void)test {
    HMLog(HMLogLevelVerbose, App, 10, @"Talk is cheap show me the code.");

    HMLogV(tag1, @"this is a verbose log and you will not see me in database.");
    HMLogI(tag1, @"this is a info log and you will not see me in database.");
    HMLogD(tag1, @"this is a debug log and you will not see me in database.");
    HMLogW(tag1, @"this is a warning log and i shall be record in database.");
    HMLogE(tag1, @"this is a error log and i shall be record in database too!");

    HMLogV(test2, @"this is a verbose log and you will not see me in database.");
    HMLogI(test2, @"this is a info log and you will not see me in database.");
    HMLogD(test2, @"this is a debug log and you will not see me in database.");
    HMLogW(test2, @"this is a warning log and i shall be record in database.");
    HMLogE(test2, @"this is a error log and i shall be record in database too!");

    NSLog(@"NSLog output format %d + %d = %d", 1, 2, 3);
    NSLog(@"NSLog output object, date is: %@", [NSDate date]);
}

- (void)batchTest {

    static HMLogLevel level = HMLogLevelVerbose;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        HMLog(level, batch, 0, @"Hello world");
        if (level == HMLogLevelFatal) {
            level = HMLogLevelVerbose;
        }
        else {
            level++;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self batchTest];
        });
    });
}

- (void)dataTest {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        Byte bytes[256] = {0};
        for (int i = 0; i < 256; i++) {
            bytes[i] = i;
        }

        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];


        for (;;) {
            HMDataLogV(Data, @"Verbose", data, @"This is a data data");
            HMDataLogI(Data, @"Info", data, @"This is a data data");
            HMDataLogD(Data, @"Debug", data, @"This is a data data");
            HMDataLogW(Data, @"Warning", data, @"This is a data data");
            HMDataLogE(Data, @"Error", data, @"This is a data log");

            [NSThread sleepForTimeInterval:0.1];
        }
    });
}

@end
