//
//  NSString+HMURL.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSString+HMURL.h"


@implementation NSString (HMURL)


#pragma mark URL地址编码
- (NSString *)encodeToPercentEscapeString {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *outputStr = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return outputStr;
}

#pragma mark URL地址解码
- (NSString *)decodeFromPercentEscapeString {
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    
    return [outputStr stringByRemovingPercentEncoding];
}

@end
