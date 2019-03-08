//
//  @fileName  UIView+HMXib.h
//  @abstract  UIView添加xib和subView
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIView (HMXib)

/**
 添加xib(默认是无边距添加)

 @param nibName 名称
 @return UIView
 */
- (UIView *)addNibNamed:(NSString *)nibName;

/**
 添加xib(默认是无边距添加，bundle为mainBundle)

 @param nibName 名称
 @param owner 属于者
 @return UIView
 */
- (UIView *)addNibNamed:(NSString *)nibName owner:(id)owner;

/**
 添加xib(默认是无边距添加,owner为self)

 @param nibName 名称
 @param bundle 属于者
 @return 所属bundle
 */
- (UIView *)addNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle;

/**
 添加xib(默认是无边距添加)

 @param nibName 名称
 @param owner 属于者
 @param bundle 所属bundle
 @return UIView
 */
- (UIView *)addNibNamed:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

/**
 添加子View(默认是无边距添加)

 @param view view
 @return UIView
 */
- (UIView *)addSubviewToFillContent:(UIView *)view;

@end
