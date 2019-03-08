//
//  @fileName  UIButton+HMCountDown.h
//  @abstract  倒计时按钮
//  @author    李林刚 创建于 2016/12/19.
//  @revise    李林刚 最后修改于 2016/12/19.
//  @version   当前版本号 1.0(2016/12/19).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HMCountDown)

@property (nonatomic, copy) NSString *countDownFormat;

@property (nonatomic, copy) NSString *finishedString;

@property (nonatomic, assign, readonly) NSTimeInterval leaveTime;

@property (nonatomic, assign) BOOL shouldChangeString;

- (void)countDownWithTimeInterval:(NSTimeInterval) duration;

- (void)reset;

- (void)stopCountDown;

@end
