//
//  NSDictionary+HMSafe.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSDictionary+HMSafe.h"


@implementation NSDictionary (HMSafe)


#pragma mark 获取字符串
- (NSString *)stringForKey:(NSString *)key {
    id result = [self objectForKey:key];
    
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",result];
    } else if (result == nil) {
        result = @"";
    } else if ([result isKindOfClass:[NSNull class]]) {
        result = @"";
    }
    
    return result;
}

#pragma mark 获取整型
- (NSInteger)integerForKey:(NSString *)key {
    return [[self objectForKey:key] integerValue];
}

#pragma mark 获取浮点型
- (float)floatForKey:(NSString *)key {
    return [[self objectForKey:key] floatValue];
}

#pragma mark 获取bool型
- (BOOL)boolForKey:(NSString *)key {
    return [[self objectForKey:key] boolValue];
}

#pragma mark 获取字典
- (NSDictionary *)dictionaryForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    NSDictionary *result = [NSDictionary dictionary];
    
    if (obj != nil && ![obj isKindOfClass:[NSNull class]]) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = obj;
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (jsonDict != nil) {
                    result = jsonDict;
                }
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            result = obj;
        }
    }
    
    return result;
}

#pragma mark 获取数组
- (NSArray *)arrayForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    NSArray *result = [NSArray array];
    
    if (obj != nil && ![obj isKindOfClass:[NSNull class]]) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = obj;
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data) {
                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                if (jsonArray != nil) {
                    result = jsonArray;
                }
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            result = obj;
        }
    }
    
    return result;
}

#pragma mark NSLog中文的时候，会显示unicode，英文正常，Xcode调试对本地化文字没有做处理 需要对象本身实现description方法才可以。
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *mulString = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [mulString appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [mulString appendString:@"}\n"];
    return mulString;
}

@end


@implementation NSMutableDictionary (HMSafe)


#pragma mark 设置Bool
- (void)setBool:(BOOL)value forKey:(NSString *)keyName {
    [self setSafeObject:[NSNumber numberWithBool:value] forKey:keyName];
}

#pragma mark 设置Float
- (void)setFloat:(float)value forKey:(NSString *)keyName {
    [self setSafeObject:[NSNumber numberWithFloat:value] forKey:keyName];
}

#pragma mark 设置Integer
- (void)setInteger:(NSInteger)value forKey:(NSString *)keyName {
    [self setSafeObject:[NSNumber numberWithInteger:value] forKey:keyName];
}

#pragma mark 设置安全Value
- (void)setSafeObject:(id)object forKey:(NSString *)keyName {
    if (!keyName) {
        NSLog(@"设置字典, key不能为nil");
        return;
    }
    
    if (!object) {
        NSLog(@"设置字典，object不能为nil");
        return;
    }
    
    [self setObject:object forKey:keyName];
}

@end

