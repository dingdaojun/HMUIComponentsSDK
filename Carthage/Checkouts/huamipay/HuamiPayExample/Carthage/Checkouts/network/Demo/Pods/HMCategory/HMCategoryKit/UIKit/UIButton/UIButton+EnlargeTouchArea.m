//
//  UIButton+EnlargeTouchArea.m
//  HMCategorySourceCodeExample
//
//  Created by 李宪 on 17-5-10.
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <objc/runtime.h>
#import "UIButton+EnlargeTouchArea.h"


@implementation UIButton (EnlargeTouchArea)


static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;


#pragma mark 设置边界
- (void)setEnlargeEdge:(CGFloat)edge {
    [self setEnlargeEdgeWithTop:edge right:edge bottom:edge
                           left:edge];
}

#pragma mark 设置边界
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark 获取边界
- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

#pragma mark 扩大边界
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden || self.alpha == 0.0) {
        return [super hitTest:point withEvent:event];
    }
    
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
