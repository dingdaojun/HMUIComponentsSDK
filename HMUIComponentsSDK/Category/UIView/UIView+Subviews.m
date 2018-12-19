//
//  UIView+Subviews.m
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIView+Subviews.h"
@import HMCategory;
#import "UIView+Size.h"

@implementation UIView (Subviews)

- (void)hm_removeAllSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)hm_addSingleSubview:(UIView *)subview {
    [self hm_removeAllSubviews];
    [self addSubviewToFillContent:subview];
}

@end
