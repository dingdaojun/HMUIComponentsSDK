//
//  @fileName  UIButton+HMLocalizableFlips.h
//  @abstract  强制翻转
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (HMLocalizableFlips)

@property (nonatomic, assign) BOOL isHMFlips;

/**
 强制翻转(注：1、此在国际化下对需要翻转但未翻转图片进行翻转；2、此方法在设置image后调用)
 */
- (void)forceFlipForLocalizable;

/**
 文本对其
 */
- (void)textAlignmentForLocalizable;

@end
