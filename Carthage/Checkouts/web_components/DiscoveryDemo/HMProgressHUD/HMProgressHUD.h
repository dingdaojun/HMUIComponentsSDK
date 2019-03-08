//
//  HMProgressHUD.h
//  HMProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 背景蒙层样式

 - HMProgressHUDMaskStyleCustom: 默认透明样式，不允许响应事件，该模式可以自定义背景颜色 @see setDefaultMaskColor：
 - HMProgressHUDMaskStyleNone: 透明背景允许响应事件
 */
typedef NS_ENUM(NSUInteger, HMProgressHUDMaskStyle) {
    HMProgressHUDMaskStyleCustom = 1,
    HMProgressHUDMaskStyleNone
};

/**
 HUD的样式

 - HMProgressHUDStyleBlack: 黑色背景白色字体
 - HMProgressHUDStyleWhite: 白色背景蓝色字体
 */
typedef NS_ENUM(NSUInteger, HMProgressHUDStyle) {
    HMProgressHUDStyleBlack,
    HMProgressHUDStyleWhite,
};

typedef NS_ENUM(NSUInteger, HMProgressHUDActivityType) {
    HMProgressHUDActivityTypeNineDots,
    HMProgressHUDActivityTypeTriplePulse,
    HMProgressHUDActivityTypeFiveDots,
    HMProgressHUDActivityTypeRotatingSquares,
    HMProgressHUDActivityTypeDoubleBounce,
    HMProgressHUDActivityTypeTwoDots,
    HMProgressHUDActivityTypeThreeDots,
    HMProgressHUDActivityTypeBallPulse,
    HMProgressHUDActivityTypeBallClipRotate,
    HMProgressHUDActivityTypeBallClipRotatePulse,
    HMProgressHUDActivityTypeBallClipRotateMultiple,
    HMProgressHUDActivityTypeBallRotate,
    HMProgressHUDActivityTypeBallZigZag,
    HMProgressHUDActivityTypeBallZigZagDeflect,
    HMProgressHUDActivityTypeBallTrianglePath,
    HMProgressHUDActivityTypeBallScale,
    HMProgressHUDActivityTypeLineScale,
    HMProgressHUDActivityTypeLineScaleParty,
    HMProgressHUDActivityTypeBallScaleMultiple,
    HMProgressHUDActivityTypeBallPulseSync,
    HMProgressHUDActivityTypeBallBeat,
    HMProgressHUDActivityTypeLineScalePulseOut,
    HMProgressHUDActivityTypeLineScalePulseOutRapid,
    HMProgressHUDActivityTypeBallScaleRipple,
    HMProgressHUDActivityTypeBallScaleRippleMultiple,
    HMProgressHUDActivityTypeTriangleSkewSpin,
    HMProgressHUDActivityTypeBallGridBeat,
    HMProgressHUDActivityTypeBallGridPulse,
    HMProgressHUDActivityTypeRotatingSanDDGlass,
    HMProgressHUDActivityTypeRotatingTrigons,
    HMProgressHUDActivityTypeTripleRings,
    HMProgressHUDActivityTypeCookieTerminator,
    HMProgressHUDActivityTypeBallSpinFadeLoader,
    HMProgressHUDActivityTypeClock,
    HMProgressHUDActivityTypeCycleSwitchImage,
};

typedef void (^HMProgressHUDDismissCompletion)(void);

@interface HMProgressHUD : UIView

/**
 *  @brief 设置默认最小消失时间,当且仅当以alter形式出现的时候生效,默认1.5s
 *
 *  @param minDismissDuration CGFloat
 */
+ (void)setDefaultMinDismissDuration:(CGFloat)minDismissDuration;
/**
 *  @brief 设置默认最大消失时间,当且仅当以alter形式出现的时候生效,默认5s
 *
 *  @param maxDismissDuration CGFloat
 */
+ (void)setDefaultMaxDismissDuration:(CGFloat)maxDismissDuration;



/**
 *  @brief 设置背景mask,默认HMProgressHUDMaskStyleCustom
 *
 *  @param maskStyle HMProgressHUDMaskStyle
 */
+ (void)setDefaultMaskStyle:(HMProgressHUDMaskStyle)maskStyle;

/**
 *  @brief 设置HUD背景,默认HMProgressHUDStyleBlack
 *
 *  @param hudStyle HMProgressHUDStyle
 */
+ (void)setDefaultHUDStyle:(HMProgressHUDStyle)hudStyle;

/**
 *  @brief 设置蒙层颜色，默认透明色，当HMProgressHUDMaskTypeCustom时生效
 *
 *  @param color UIColor
 */
+ (void)setDefaultMaskColor:(UIColor *)color;

/**
 *  @brief 设置HUD默认背景色,默认黑色
 *
 *  @param color UIColor
 */
+ (void)setDefaultHUDBackGroudColor:(UIColor *)color;
/**
 *  @brief 设置HUD默认圆角半径,默认4.0
 *
 *  @param cornerRadius CGFloat
 */
+ (void)setDefaultHUDCornerRadius:(CGFloat)cornerRadius;
/**
 *  @brief 设置HUD默认阴影颜色,默认0.82透明度的黑色
 *
 *  @param color UIColor
 */
+ (void)setDefaultHUDShadowColor:(UIColor *)color;
/**
 *  @brief 设置HUD默认阴影偏移,默认CGSize(2.0,2.0)
 *
 *  @param shadowOffset CGSize
 */
+ (void)setDefaultHUDShadowOffset:(CGSize)shadowOffset;
/**
 *  @brief 设置HUD默认阴影扩散半径,默认8.0
 *
 *  @param shadowRadius CGFloat
 */
+ (void)setDefaultHUDShadowRadius:(CGFloat)shadowRadius;


/**
 *  @brief 设置默认活动指示器动画，默认HMProgressHUDActivityTypeLineChange
 *
 *  @param activityType HMProgressHUDActivityType
 */
+ (void)setDefaultActivityType:(HMProgressHUDActivityType)activityType;
/**
 *  @brief 设置默认的活动指示器颜色，默认whiteColor
 *
 *  @param activityColor UIColor
 */
+ (void)setDefaultActivityColor:(UIColor *)activityColor;
/**
 *  @brief 设置默认活动指示器大小, 默认25.0
 *
 *  @param activitySize CGFloat
 */
+ (void)setDefaultActivitySize:(CGFloat)activitySize;


/**
 *  @brief 设置默认的主题颜色，默认白色 eg 文字 loading状态颜色
 *
 *  @param tintColor UIColor
 */
+ (void)setDefaultTintColor:(UIColor *)tintColor;
/**
 *  @brief 设置text字体大小,默认12pt
 *
 *  @param font UIFont
 */
+ (void)setDefaultFont:(UIFont *)font;
/**
 *  @brief 设置text行间距,默认8.0f
 *
 *  @param lineSpacing CGFloat
 */
+ (void)setDefaultLineSpacing:(CGFloat)lineSpacing;


/**
 *  @brief 设置成功alter图片,默认为bundle中的图片
 *
 *  @param image UIImage
 */
+ (void)setDefaultSuccessImage:(UIImage *)image;
/**
 *  @brief 设置错误alter图片,默认为bundle中的图片
 *
 *  @param image UIImage
 */
+ (void)setDefaultErrorImage:(UIImage *)image;



/**
 *  @brief 显示一个无限等待提示框
 *
 *  @param status 提示文案
 */
+ (void)showHUDWithStatus:(NSString*)status;

/**
 *  @brief 显示一个纯文本提示框并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showWithStatus:(NSString*)status;

/**
 *  @brief 显示一个纯文本提示框并在短暂时间后消失
 *
 *  @param status 提示文案
 *  @param completion 消失后的回调
 */
+ (void)showWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion;

/**
 *  @brief 显示一个带有默认成功图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showSucessWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认成功图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 *  @param completion 消失后的回调
 */
+ (void)showSucessWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion;

/**
 *  @brief 显示一个带有默认失败图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 */
+ (void)showErrorWithStatus:(NSString*)status;

/**
 *  @brief 显示一个带有默认失败图片的提示并在短暂时间后消失
 *
 *  @param status 提示文案
 *  @param completion 消失后的回调
 */
+ (void)showErrorWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion;


/**
 *  @brief 立即消失
 */
+ (void)dismiss;
/**
 *  @brief 立即消失并返回一个callback
 *
 *  @param completion 回调
 */
+ (void)dismissWithCompletion:(HMProgressHUDDismissCompletion)completion;
/**
 *  @brief 一段延迟后消失
 *
 *  @param delay 延迟时间
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay;
/**
 *  @brief 一段时间延迟后消失并返回一个回调
 *
 *  @param delay      延迟时间
 *  @param completion 回调
 */
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(HMProgressHUDDismissCompletion)completion;

@end
