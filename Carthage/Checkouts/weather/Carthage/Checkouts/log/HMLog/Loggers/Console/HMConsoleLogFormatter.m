//
//  HMConsoleLogFormatter.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMConsoleLogFormatter.h"
#import "HMLogItem.h"


@implementation HMConsoleLogFormatter

#pragma mark - format text segment

- (NSString *)dateTextWithItem:(HMLogItem *)item {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
    return [formatter stringFromDate:item.time];
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

#pragma mark - HMConsoleLogFormatter

- (NSString *)formattedTextWithItem:(HMLogItem *)item {
    
    NSString *text = @"";

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

@end
