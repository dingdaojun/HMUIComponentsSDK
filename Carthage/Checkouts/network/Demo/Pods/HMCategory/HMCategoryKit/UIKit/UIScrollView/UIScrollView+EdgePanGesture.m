//
//  UIScrollView+EdgePanGesture.m
//  VeryZhun
//
//  Created by xianli on 16/4/5.
//  Copyright © 2016年 listener~. All rights reserved.
//


#import "UIScrollView+EdgePanGesture.h"
#import <objc/runtime.h>


static NSString * const kEnableEdgePanGestureProperty = @"kEnableEdgePanGestureProperty";
static NSString * const kUIScreenEdgePanGestureRecognizer = @"kUIScreenEdgePanGestureRecognizer";


@implementation UIScrollView (EdgePanGesture)


#pragma mark - Public Method
#pragma mark 开启
- (void)enableEdgePanGesture {
    objc_setAssociatedObject(self, "enableEdgePanGesture", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 关闭
- (void)disableEdgePanGesture {
    objc_setAssociatedObject(self, "enableEdgePanGesture", @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        NSNumber *isEnableEdgePanGesture = objc_getAssociatedObject(self, "enableEdgePanGesture");
        return isEnableEdgePanGesture.boolValue;
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        NSNumber *isEnableEdgePanGesture = objc_getAssociatedObject(self, "enableEdgePanGesture");
        return isEnableEdgePanGesture.boolValue;
    }
    
    return NO;
}

@end
