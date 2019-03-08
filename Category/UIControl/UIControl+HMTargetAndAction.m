//
//  UIControl+HMTargetAndAction.m
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/11/28.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIControl+HMTargetAndAction.h"
#import <UIKit/UIKit.h>
@implementation UIControl (HMTargetAndAction)

- (void)hmRemoveAllTargetsAndActions {
    [self.allTargets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:NULL forControlEvents:UIControlEventTouchUpInside];
    }];
}

@end
