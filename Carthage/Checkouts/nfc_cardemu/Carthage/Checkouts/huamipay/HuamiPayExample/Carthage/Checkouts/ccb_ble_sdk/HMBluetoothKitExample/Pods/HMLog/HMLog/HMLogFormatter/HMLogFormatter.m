//
//  HMLogFormatter.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogFormatter.h"

#import "HMLogItem.h"
#import "HMLogConfiguration+Keys.h"

@implementation HMLogFormatter

#pragma mark - format text segment

- (NSString *)seperatorTextWithItem:(HMLogItem *)item {
    
    if ([self.configuration boolForKey:HMConfigurationKeyConsoleHideSeperator]) {
        return @"";
    }
    
    NSString *seperator = @"---------------------------------------------------------------------------------------------------------------------------\n";
    return seperator;
}

- (NSString *)dateTextWithItem:(HMLogItem *)item {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
    
    NSInteger timeZone = [self.configuration integerForKey:HMConfigurationKeyConsoleTimeZone];
    NSInteger seconds = timeZone * 3600;
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:seconds];
    
    return [formatter stringFromDate:item.date];
}

- (NSString *)levelTextWithItem:(HMLogItem *)item {
    return item.levelText;
}

- (NSString *)tagTextWithItem:(HMLogItem *)item {
    return item.tag;
}

- (NSString *)traceTextWithItem:(HMLogItem *)item {
    return [item.function stringByAppendingFormat:@"- %04d -", (int)item.line];
}

- (NSString *)contentTextWithItem:(HMLogItem *)item {
    
    NSString *text = item.content;
    
    if (item.stackLevel > 0) {
        text = [text stringByAppendingFormat:@"\nStackSymbols are: \n%@\n", item.stackSymbols];
    }
    
    return text;
}

#pragma mark - HMLoggerFormatter

- (NSString *)formattedTextWithItem:(HMLogItem *)item {
    
    NSString *text = @"";
    
    text = [text stringByAppendingString:[self seperatorTextWithItem:item]];
    text = [text stringByAppendingString:[self dateTextWithItem:item]];
    text = [text stringByAppendingString:@"|"];
    text = [text stringByAppendingString:[self levelTextWithItem:item]];
    text = [text stringByAppendingString:@"|"];
    text = [text stringByAppendingString:[self tagTextWithItem:item]];
    text = [text stringByAppendingString:@"|"];
    text = [text stringByAppendingString:[self traceTextWithItem:item]];
    text = [text stringByAppendingString:@"|"];
    text = [text stringByAppendingString:[self contentTextWithItem:item]];
    text = [text stringByAppendingString:@"\n"];

    return text;
}

#pragma mark - Factory

+ (instancetype)formatterWithConfiguration:(HMLogConfiguration *)configuration {
    HMLogFormatter *formatter = [[[self class] alloc] init];
    formatter.configuration = configuration;
    return formatter;
}

@end
