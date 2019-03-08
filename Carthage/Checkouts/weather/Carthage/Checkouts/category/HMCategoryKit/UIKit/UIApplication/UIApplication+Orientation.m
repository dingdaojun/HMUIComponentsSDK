//
//  UIApplication+Orientation.m
//  MiFit
//
//  Created by fan weirong on 2017/1/9.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIApplication+Orientation.h"


static UIInterfaceOrientationMask allowScreenRotation;


@implementation UIApplication (Orientation)


#pragma mark 更新方向
- (void)updateOrientationMark:(UIInterfaceOrientationMask)orientationMark {
    allowScreenRotation = orientationMark;
}

#pragma mark 获取方向
- (UIInterfaceOrientationMask)allowScreenOrientationMark {
    return allowScreenRotation;
}

@end
