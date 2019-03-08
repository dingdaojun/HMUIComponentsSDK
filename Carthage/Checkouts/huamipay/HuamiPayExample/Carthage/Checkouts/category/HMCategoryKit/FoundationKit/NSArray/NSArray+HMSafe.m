//
//  NSArray+HMSafe.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/17.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "NSArray+HMSafe.h"


@implementation NSArray (HMSafe)


#pragma mark 安全的获取数据，保证不越界
- (id)objectAtSafeIndex:(NSInteger)index {
    if ([self count] > index) {
        id object = [self objectAtIndex:index];
        
        if ([object isKindOfClass:[NSNull class]]) {
            return nil;
        } else {
            return object;
        }
    } else {
        NSLog(@"数组越界了:%lu 数组长度:%lu",(unsigned long)index,(unsigned long)self.count);
        return nil;
    }
}

#pragma mark NSLog中文的时候，会显示unicode，英文正常，Xcode调试对本地化文字没有做处理 需要对象本身实现description方法才可以。
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *mulString = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mulString appendFormat:@"\t%@,\n", obj];
    }];
    
    [mulString appendString:@")"];
    
    return mulString;
}

@end


@implementation NSMutableArray (HMSafe)


#pragma mark 安全添加
- (void)addSafeObject:(id)object {
    if (![object isKindOfClass:[NSNull class]] && object) {
        [self addObject:object];
    } else {
        NSLog(@"Error hmAddSafeObject is nil");
    }
}

#pragma mark 安全插入
- (void)insertSafeObject:(id)object atIndex:(NSInteger)index {
    if (![object isKindOfClass:[NSNull class]] && object && index <= self.count && index >= 0) {
        [self insertObject:object atIndex:index];
    } else {
        NSLog(@"Error insertSafeObject:%@ index:%lu count:%lu",object,(unsigned long)index,(unsigned long)self.count);
    }
}

#pragma mark 安全删除
- (void)removeObjectAtSafeIndex:(NSInteger)index {
    if ([self count] > index) {
        [self removeObjectAtIndex:index];
    } else {
        NSLog(@"removeObjectAtSafeIndex:%lu 数组长度:%lu",(unsigned long)index,(unsigned long)self.count);
    }
}

@end
