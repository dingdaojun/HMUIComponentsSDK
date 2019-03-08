//
//  HMConsoleLogger.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMConsoleLogger.h"

#import "HMLogItem.h"
#import "HMLogFormatter.h"
#import "HMLogConfiguration+Keys.h"

@interface HMConsoleLogger ()

@property (nonatomic, strong, readonly) NSArray *filterLevels;
@property (nonatomic, strong, readonly) NSArray *filterTags;

@end


@implementation HMConsoleLogger

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

#pragma mark - setter and getter

- (NSArray *)filterLevels {
    HMLogConfiguration *configuration = self.configuration;
    return [configuration arrayForKey:HMConfigurationKeyConsoleFilterLevels];
}

- (NSArray *)filterTags {
    HMLogConfiguration *configuration = self.configuration;
    return [configuration arrayForKey:HMConfigurationKeyConsoleFilterTags];
}

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {
 
#if DEBUG
    
    if (![self shouldRecordItem:item]) {
        return;
    }
    
    if (!self.formatter) {
        self.formatter = [HMLogFormatter formatterWithConfiguration:self.configuration];
    }
    
    NSString *formattedText = [self.formatter formattedTextWithItem:item];
    fprintf(stderr, "%s", formattedText.UTF8String);
#endif
}

@end
