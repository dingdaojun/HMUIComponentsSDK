//
//  NSAttributedString+HMUtility.m
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSAttributedString+HMUtility.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation NSAttributedString (HMUtility)

- (NSUInteger)hmBoundingNumberOfLinesWithSize:(CGSize)size {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self];

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];

    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
    [layoutManager addTextContainer:textContainer];

    NSUInteger numberOfLines, index;
    NSUInteger numberOfGlyphs = [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++) {
        [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    return numberOfLines;
}

@end
