//
//  NSArray+HMJson.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/10.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSArray+HMJson.h"


@implementation NSArray (HMJson)


#pragma mark 转JSON字符串
- (NSString *)toJSON:(BOOL)isFormat {
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"NSArray toJSON error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (isFormat) {
            NSString *string = [jsonString stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            jsonString = string;
        }
    }
    
    return jsonString;
}

#pragma mark 转JSON Data
- (NSData *)toJSONData {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Array toJSONData: error: %@", error.localizedDescription);
        return nil;
    } else {
        return jsonData;
    }
}

@end
