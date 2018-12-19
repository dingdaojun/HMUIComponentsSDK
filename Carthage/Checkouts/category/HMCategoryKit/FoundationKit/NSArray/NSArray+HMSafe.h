//
//  @fileName  NSArray+HMSafe.h
//  @abstract  安全获取和设置array
//  @author    余彪 创建于 2017/5/10.
//  @revise    余彪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSArray (HMSafe)

/**
 安全的获取数据，保证不越界
 
 @param index index
 @return id
 */
- (id)objectAtSafeIndex:(NSInteger)index;

@end


@interface NSMutableArray (HMSafe)

/**
 安全添加
 
 @param object 元素
 */
- (void)addSafeObject:(id)object;

/**
 安全插入
 
 @param object 元素
 @param index index
 */
- (void)insertSafeObject:(id)object atIndex:(NSInteger)index;

/**
 安全删除
 
 @param index index
 */
- (void)removeObjectAtSafeIndex:(NSInteger)index;

@end
