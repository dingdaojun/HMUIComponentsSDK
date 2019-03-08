//
//  NSDictionary+HMJson.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/10.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDictionary+HMJson.h"


@implementation NSDictionary (HMJson)


#pragma mark 转JSON
- (NSString *)toJSON:(BOOL)isFormat {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"NSDictionary toJSON: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (isFormat) {
            NSString *string = [jsonString stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            jsonString = string;
        }
        
        return jsonString;
    }
}

#pragma mark 将Json转NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    
    return nil;
}

@end
