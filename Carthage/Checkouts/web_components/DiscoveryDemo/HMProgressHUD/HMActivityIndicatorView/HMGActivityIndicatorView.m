//
//  HMGActivityIndicatorView.m
//  HMGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "HMGActivityIndicatorView.h"

#import "HMGActivityIndicatorNineDotsAnimation.h"
#import "HMGActivityIndicatorTriplePulseAnimation.h"
#import "HMGActivityIndicatorFiveDotsAnimation.h"
#import "HMGActivityIndicatorRotatingSquaresAnimation.h"
#import "HMGActivityIndicatorDoubleBounceAnimation.h"
#import "HMGActivityIndicatorTwoDotsAnimation.h"
#import "HMGActivityIndicatorThreeDotsAnimation.h"
#import "HMGActivityIndicatorBallPulseAnimation.h"
#import "HMGActivityIndicatorBallClipRotateAnimation.h"
#import "HMGActivityIndicatorBallClipRotatePulseAnimation.h"
#import "HMGActivityIndicatorBallClipRotateMultipleAnimation.h"
#import "HMGActivityIndicatorBallRotateAnimation.h"
#import "HMGActivityIndicatorBallZigZagAnimation.h"
#import "HMGActivityIndicatorBallZigZagDeflectAnimation.h"
#import "HMGActivityIndicatorBallTrianglePathAnimation.h"
#import "HMGActivityIndicatorBallScaleAnimation.h"
#import "HMGActivityIndicatorLineScaleAnimation.h"
#import "HMGActivityIndicatorLineScalePartyAnimation.h"
#import "HMGActivityIndicatorBallScaleMultipleAnimation.h"
#import "HMGActivityIndicatorBallPulseSyncAnimation.h"
#import "HMGActivityIndicatorBallBeatAnimation.h"
#import "HMGActivityIndicatorLineScalePulseOutAnimation.h"
#import "HMGActivityIndicatorLineScalePulseOutRapidAnimation.h"
#import "HMGActivityIndicatorBallScaleRippleAnimation.h"
#import "HMGActivityIndicatorBallScaleRippleMultipleAnimation.h"
#import "HMGActivityIndicatorTriangleSkewSpinAnimation.h"
#import "HMGActivityIndicatorBallGridBeatAnimation.h"
#import "HMGActivityIndicatorBallGridPulseAnimation.h"
#import "HMGActivityIndicatorRotatingSandglassAnimation.h"
#import "HMGActivityIndicatorRotatingTrigonAnimation.h"
#import "HMGActivityIndicatorTripleRingsAnimation.h"
#import "HMGActivityIndicatorCookieTerminatorAnimation.h"
#import "HMGActivityIndicatorBallSpinFadeLoader.h"
#import "HMGActivityIndicatorClockAnimation.h"
#import "HMGActivityIndicatorCycleSwitchImageAnimation.h"

static const CGFloat kHMGActivityIndicatorDefaultSize = 40.0f;

@interface HMGActivityIndicatorView () {
    CALayer *_animationLayer;
}

@end

@implementation HMGActivityIndicatorView

#pragma mark -
#pragma mark Constructors

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = kHMGActivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(HMGActivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kHMGActivityIndicatorDefaultSize];
}

- (id)initWithType:(HMGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kHMGActivityIndicatorDefaultSize];
}

- (id)initWithType:(HMGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<HMGActivityIndicatorAnimationProtocol> animation = [HMGActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        if (_animationLayer.sublayers) {
            for (CALayer * layer in _animationLayer.sublayers) {
                [layer removeFromSuperlayer];
            }
        }
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        _animationLayer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(HMGActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;
            
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<HMGActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(HMGActivityIndicatorAnimationType)type {
    switch (type) {
        case HMGActivityIndicatorAnimationTypeNineDots:
            return [[HMGActivityIndicatorNineDotsAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeTriplePulse:
            return [[HMGActivityIndicatorTriplePulseAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeFiveDots:
            return [[HMGActivityIndicatorFiveDotsAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeRotatingSquares:
            return [[HMGActivityIndicatorRotatingSquaresAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeDoubleBounce:
            return [[HMGActivityIndicatorDoubleBounceAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeTwoDots:
            return [[HMGActivityIndicatorTwoDotsAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeThreeDots:
            return [[HMGActivityIndicatorThreeDotsAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallPulse:
            return [[HMGActivityIndicatorBallPulseAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallClipRotate:
            return [[HMGActivityIndicatorBallClipRotateAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallClipRotatePulse:
            return [[HMGActivityIndicatorBallClipRotatePulseAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallClipRotateMultiple:
            return [[HMGActivityIndicatorBallClipRotateMultipleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallRotate:
            return [[HMGActivityIndicatorBallRotateAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallZigZag:
            return [[HMGActivityIndicatorBallZigZagAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallZigZagDeflect:
            return [[HMGActivityIndicatorBallZigZagDeflectAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallTrianglePath:
            return [[HMGActivityIndicatorBallTrianglePathAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallScale:
            return [[HMGActivityIndicatorBallScaleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeLineScale:
            return [[HMGActivityIndicatorLineScaleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeLineScaleParty:
            return [[HMGActivityIndicatorLineScalePartyAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallScaleMultiple:
            return [[HMGActivityIndicatorBallScaleMultipleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallPulseSync:
            return [[HMGActivityIndicatorBallPulseSyncAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallBeat:
            return [[HMGActivityIndicatorBallBeatAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeLineScalePulseOut:
            return [[HMGActivityIndicatorLineScalePulseOutAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeLineScalePulseOutRapid:
            return [[HMGActivityIndicatorLineScalePulseOutRapidAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallScaleRipple:
            return [[HMGActivityIndicatorBallScaleRippleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallScaleRippleMultiple:
            return [[HMGActivityIndicatorBallScaleRippleMultipleAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeTriangleSkewSpin:
            return [[HMGActivityIndicatorTriangleSkewSpinAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallGridBeat:
            return [[HMGActivityIndicatorBallGridBeatAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeBallGridPulse:
            return [[HMGActivityIndicatorBallGridPulseAnimation alloc] init];
        case HMGActivityIndicatorAnimationTypeRotatingSanDDGlass:
            return [[HMGActivityIndicatorRotatingSandglassAnimation alloc]init];
        case HMGActivityIndicatorAnimationTypeRotatingTrigons:
            return [[HMGActivityIndicatorRotatingTrigonAnimation alloc]init];
        case HMGActivityIndicatorAnimationTypeTripleRings:
            return [[HMGActivityIndicatorTripleRingsAnimation alloc]init];
        case HMGActivityIndicatorAnimationTypeCookieTerminator:
            return [[HMGActivityIndicatorCookieTerminatorAnimation alloc]init];
        case HMGActivityIndicatorAnimationTypeBallSpinFadeLoader:
            return [[HMGActivityIndicatorBallSpinFadeLoader alloc] init];
        case HMGActivityIndicatorAnimationTypeClock:
            return [[HMGActivityIndicatorClockAnimation alloc] init];
        case HMGActivityIndicatorCycleSwitchImage:
            return [[HMGActivityIndicatorCycleSwitchImageAnimation alloc] init];
        default:
            break;
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;
    
    if (_animating) {
        [self stopAnimating];
        [self setupAnimation];
        [self startAnimating];
    }
}

@end
