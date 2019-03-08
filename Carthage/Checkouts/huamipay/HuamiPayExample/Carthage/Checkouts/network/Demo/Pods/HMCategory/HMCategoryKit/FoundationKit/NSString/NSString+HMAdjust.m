//
//  NSString+HMAdjust.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSString+HMAdjust.h"


@implementation NSString (HMAdjust)


#pragma mark 去除字符串两端的空格
- (NSString *)trimEndsSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 去除字符串所有的空格
- (NSString *)trimAllSpace {
    return  [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}

#pragma mark 去除字符串特殊符号 \n \t \r
- (NSString *)trimSpecialCode {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return string;
}

#pragma mark 字符串转字典
- (NSDictionary *)toDictionaryWithError:(NSError *__autoreleasing *)error {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
    
    if (error) {
        NSLog(@"string to dictionary error: %@",*error);
    }
    
    if (![dictionary isKindOfClass:[NSDictionary class]] || !dictionary) {
        NSLog(@"string to dictionary error: dictionary = nil");
        return nil;
    }
    
    return dictionary;
}

#pragma mark 字符串转数组
- (NSArray *)toArrayWithError:(NSError *__autoreleasing *)error {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
    
    if (error) {
        NSLog(@"string to array error:%@",*error);
    }
    
    if (![array isKindOfClass:[NSArray class]] || !array) {
        NSLog(@"string to array error: array = nil");
        return nil;
    }
    
    return array;
}



@end
