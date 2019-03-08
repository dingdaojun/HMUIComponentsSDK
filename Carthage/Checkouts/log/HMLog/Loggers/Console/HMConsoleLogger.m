//
//  HMConsoleLogger.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMConsoleLogger.h"

#import "HMLogItem.h"
#import "HMConsoleLogFormatter.h"


@implementation HMConsoleLogger

+ (instancetype)sharedLogger {
    static dispatch_once_t onceToken;
    static HMConsoleLogger *logger;
    dispatch_once(&onceToken, ^{
        logger = [self new];
    });
    return logger;
}

#pragma mark - private

- (BOOL)shouldRecordItem:(HMLogItem *)item {

    NSNumber *levelValue = @(item.level);
    if (self.filterLevels.count > 0 &&
        ![self.filterLevels containsObject:levelValue]) {
        return NO;
    }
    
    if (self.filterTags.count > 0 &&
        ![self.filterTags containsObject:item.tag]) {
            return NO;
    }
         
    return YES;
}

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {
    if (![self shouldRecordItem:item]) {
        return;
    }

    @synchronized(self) {
        if (!self.formatter) {
            self.formatter = [HMConsoleLogFormatter new];
        }
    }
    
    NSString *formattedText = [self.formatter formattedTextWithItem:item];
    fprintf(stderr, "%s", formattedText.UTF8String);
}

@end
