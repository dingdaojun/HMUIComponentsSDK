//
//  NSNotificationCenter+block.m
//  Nextdoors
//
//  Created by 李宪 on 17/5/10.
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import "NSNotificationCenter+Block.h"
#import <objc/runtime.h>


typedef BOOL(^NSNotifcationCenterWrapBlockType)(NSNotification *notification);

@interface NSNotificationCenter (BlockPrivate)
@property (class, nonatomic, strong, readonly) NSMutableDictionary *blockEnents;
@end


@implementation NSNotificationCenter (Block)


+ (NSMutableDictionary *)blockEvents {
    NSMutableDictionary *blockEvents = objc_getAssociatedObject(self, "blockEvents");
    
    if (!blockEvents) {
        blockEvents = [NSMutableDictionary new];
        objc_setAssociatedObject(self, "blockEvents", blockEvents, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return blockEvents;
}

#pragma mark - Public
+ (void)addBlockObserver:(id)observer
                   event:(NSNotificationName)event
                  object:(id)object
                   block:(NSNotificationCenterBlockType)block {
    NSParameterAssert(event.length > 0);
    NSParameterAssert(block);
    
    if (!observer) {
        return;
    }
    
    NSMutableDictionary *eventDictionary = self.blockEvents[event];
    
    if (!eventDictionary) {
        eventDictionary = [NSMutableDictionary new];
        self.blockEvents[event] = eventDictionary;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveNotification:)
                                                     name:event
                                                   object:nil];
    }
    
    __weak __typeof(observer) weakTarget = observer;
    NSNotifcationCenterWrapBlockType intenalBlock = ^(NSNotification *notification) {
        if (!weakTarget) {
            return NO;
        }
        
        if (!object || object == notification.object) {
            block(notification.object, notification.userInfo);
        }
        
        return YES;
    };
    
    NSString *targetKey = [NSString stringWithFormat:@"%@(%p)", NSStringFromClass([observer class]), observer];
    eventDictionary[targetKey] = intenalBlock;
}

+ (void)removeBlockObserver:(id)observer fromEvent:(NSString *)event {
    if (!observer) {
        return;
    }
    
    NSMutableDictionary *eventDictionary = self.blockEvents[event];
    
    if (!eventDictionary) {
        return;
    }
    
    NSString *targetKey = [NSString stringWithFormat:@"%@(%p)", NSStringFromClass([observer class]), observer];
    [eventDictionary removeObjectForKey:targetKey];
}

+ (void)removeBlockObserver:(id)observer {
    if (!observer) {
        return;
    }
    
    NSString *targetKey = [NSString stringWithFormat:@"%@(%p)", NSStringFromClass([observer class]), observer];
    [self.blockEvents enumerateKeysAndObjectsUsingBlock:^(NSString *event, NSMutableDictionary *eventDictionary, BOOL *stop) {
        [eventDictionary removeObjectForKey:targetKey];
    }];
}

#pragma mark - Private
+ (void)didReceiveNotification:(NSNotification *)notification {
    NSString *event = notification.name;
    NSMutableDictionary *eventDictionary = self.blockEvents[event];
    
    [eventDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNotifcationCenterWrapBlockType wrapBlock, BOOL *stop) {
       
        if (!wrapBlock(notification)) {
            [eventDictionary removeObjectForKey:key];
        }
    }];
    
    if (eventDictionary.count == 0) {
        [self.blockEvents removeObjectForKey:event];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:event object:nil];
    }
}

@end
