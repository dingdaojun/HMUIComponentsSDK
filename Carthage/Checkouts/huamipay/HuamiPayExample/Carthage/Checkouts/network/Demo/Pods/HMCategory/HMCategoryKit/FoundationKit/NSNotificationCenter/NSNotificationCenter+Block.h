//
//  @fileName  NSNotificationCenter+Block.h
//  @abstract  NSNotificationCenter 快捷回调
//  @author    李宪 创建于 2017/5/10.
//  @revise    李宪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 回调Block

 @param object object
 @param userInfo 信息
 */
typedef void(^NSNotificationCenterBlockType)(id object, NSDictionary *userInfo);


@interface NSNotificationCenter (Block)

/**
 添加observer
 如果observer被释放了，则内部会自动解除订阅。无需手动remove
 */
+ (void)addBlockObserver:(id)observer
                   event:(NSNotificationName)event
                  object:(id)object
                   block:(NSNotificationCenterBlockType)block;

/**
 为特定event移除某个observer
 */
+ (void)removeBlockObserver:(id)observer fromEvent:(NSNotificationName)event;

/**
 为所有event移除某个observer
 */
+ (void)removeBlockObserver:(id)observer;

@end
