//
//  HMFileLogFormatter.m
//  Mac
//
//  Created by 李宪 on 2018/5/25.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMFileLogFormatter.h"
#import "HMLogItem.h"


@implementation HMFileLogFormatter

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

- (NSString *)dataTextWithItem:(HMLogItem *)item {

    NSData *data = item.data;
    if (data.length == 0) {
        return @"null";
    }

    NSString *text          = @"";

    text                    = [text stringByAppendingString:@"    \t******** ******** ******** ******** ******** ******** ******** ******** \t\t\t**** **** **** **** **** **** **** ****\n"];

    NSUInteger length       = data.length;
    const Byte *p           = (const Byte *)data.bytes;

    NSUInteger rowCount     = length / 32;

    for (int i = 0; i < rowCount; i++) {

        NSString *rowText       = [NSString stringWithFormat:@"%04d\t", (int)i];

        NSString *binaryText    = @"";
        NSString *asciiText     = @"";

        for (int j = 0; j < 32; j++) {
            Byte c      = p[i * 32 + j];

            binaryText  = [binaryText stringByAppendingFormat:@"%02X", c];

            if (c >= ' ' && c <= '~') {
                asciiText   = [asciiText stringByAppendingFormat:@"%c", c];
            }
            else {
                asciiText   = [asciiText stringByAppendingString:@" "];
            }

            if ((j + 1) % 4 == 0) {
                binaryText  = [binaryText stringByAppendingString:@" "];
                asciiText   = [asciiText stringByAppendingString:@" "];
            }
        }

        rowText = [rowText stringByAppendingFormat:@"%@\t\t\t%@\n", binaryText, asciiText];
        text = [text stringByAppendingString:rowText];
    }

    NSUInteger remainCharactersCount    = length % 32;
    if (remainCharactersCount > 0) {
        NSString *rowText                   = [NSString stringWithFormat:@"%04d\t", (int)rowCount];

        NSString *binaryText    = @"";
        NSString *asciiText     = @"";

        for (int j = 0; j < 32; j++) {

            if (j < remainCharactersCount) {
                Byte c      = p[32 * rowCount + j];

                binaryText  = [binaryText stringByAppendingFormat:@"%02X", c];

                if (c >= ' ' && c <= '~') {
                    asciiText   = [asciiText stringByAppendingFormat:@"%c", c];
                }
                else {
                    asciiText   = [asciiText stringByAppendingString:@" "];
                }

                if ((j + 1) % 4 == 0) {
                    binaryText  = [binaryText stringByAppendingString:@" "];
                    asciiText   = [asciiText stringByAppendingString:@" "];
                }
            }
            else {
                binaryText  = [binaryText stringByAppendingFormat:@"  "];
                if ((j + 1) % 4 == 0) {
                    binaryText  = [binaryText stringByAppendingString:@" "];
                }
            }
        }

        rowText = [rowText stringByAppendingFormat:@"%@\t\t\t%@\n", binaryText, asciiText];
        text = [text stringByAppendingString:rowText];
    }

    text = [text stringByAppendingString:@"\n\n"];

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
    text = [text stringByAppendingString:[self dataTextWithItem:item]];

    return text;
}

@end
