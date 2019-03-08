//
//  HMGActivityIndicatorView.h
//  HMGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HMGActivityIndicatorAnimationType) {
    HMGActivityIndicatorAnimationTypeNineDots,
    HMGActivityIndicatorAnimationTypeTriplePulse,
    HMGActivityIndicatorAnimationTypeFiveDots,
    HMGActivityIndicatorAnimationTypeRotatingSquares,
    HMGActivityIndicatorAnimationTypeDoubleBounce,
    HMGActivityIndicatorAnimationTypeTwoDots,
    HMGActivityIndicatorAnimationTypeThreeDots,
    HMGActivityIndicatorAnimationTypeBallPulse,
    HMGActivityIndicatorAnimationTypeBallClipRotate,
    HMGActivityIndicatorAnimationTypeBallClipRotatePulse,
    HMGActivityIndicatorAnimationTypeBallClipRotateMultiple,
    HMGActivityIndicatorAnimationTypeBallRotate,
    HMGActivityIndicatorAnimationTypeBallZigZag,
    HMGActivityIndicatorAnimationTypeBallZigZagDeflect,
    HMGActivityIndicatorAnimationTypeBallTrianglePath,
    HMGActivityIndicatorAnimationTypeBallScale,
    HMGActivityIndicatorAnimationTypeLineScale,
    HMGActivityIndicatorAnimationTypeLineScaleParty,
    HMGActivityIndicatorAnimationTypeBallScaleMultiple,
    HMGActivityIndicatorAnimationTypeBallPulseSync,
    HMGActivityIndicatorAnimationTypeBallBeat,
    HMGActivityIndicatorAnimationTypeLineScalePulseOut,
    HMGActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    HMGActivityIndicatorAnimationTypeBallScaleRipple,
    HMGActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    HMGActivityIndicatorAnimationTypeTriangleSkewSpin,
    HMGActivityIndicatorAnimationTypeBallGridBeat,
    HMGActivityIndicatorAnimationTypeBallGridPulse,
    HMGActivityIndicatorAnimationTypeRotatingSanDDGlass,
    HMGActivityIndicatorAnimationTypeRotatingTrigons,
    HMGActivityIndicatorAnimationTypeTripleRings,
    HMGActivityIndicatorAnimationTypeCookieTerminator,
    HMGActivityIndicatorAnimationTypeBallSpinFadeLoader,
    HMGActivityIndicatorAnimationTypeClock,
    HMGActivityIndicatorCycleSwitchImage,
};

@interface HMGActivityIndicatorView : UIView

- (id)initWithType:(HMGActivityIndicatorAnimationType)type;
- (id)initWithType:(HMGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(HMGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) HMGActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
