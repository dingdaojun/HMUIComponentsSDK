//
//  HMGActivityIndicatorCycleSwitchImageAnimation.m
//  HMHealth
//
//  Created by 李林刚 on 2017/3/20.
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import "HMGActivityIndicatorCycleSwitchImageAnimation.h"

@interface HMGACycleSwitchImageWeakTimerTarget : NSObject

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL selector;

@property (nonatomic, weak) NSTimer* timer;

@end

@implementation HMGACycleSwitchImageWeakTimerTarget

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats {
    HMGACycleSwitchImageWeakTimerTarget *timerTarget = [[HMGACycleSwitchImageWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget 
                                                       selector:@selector(fire:) 
                                                       userInfo:userInfo 
                                                        repeats:repeats]; 
    return timerTarget.timer; 
}

- (void)fire:(NSTimer *)timer {
    if(self.target) {
        _Pragma("clang diagnostic push")
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
        [self.target performSelector:self.selector withObject:timer.userInfo];
        _Pragma("clang diagnostic pop")
    } else {
        [self.timer invalidate];
    } 
}

@end

@interface HMGActivityIndicatorImageLayer : CAShapeLayer

@property (nonatomic, copy) NSArray *imageNameArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HMGActivityIndicatorImageLayer

- (instancetype)init{
    self = [super init];
    if (self) {
        self.currentIndex = 0;
        self.imageNameArray = @[@"loading_icon_ecg",@"loading_icon_heartrate",@"loading_icon_sleep",@"loading_icon_smile",@"loading_icon_step"];
    }
    return self;
}

- (void)startAnimation {
    [self switchImageAnimation];
    self.timer = [HMGACycleSwitchImageWeakTimerTarget scheduledTimerWithTimeInterval:2 target:self selector:@selector(switchImageAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark -  Private Methods

- (NSString *)currentShowImageName {
    NSInteger randomIndex = self.currentIndex % [self.imageNameArray count];
    NSString *imageName = self.imageNameArray[randomIndex];
    self.currentIndex++;
    return imageName;
}

- (void)switchImageAnimation {
    [self removeAllAnimations];
    self.opacity = 0;
    UIImage *image = [UIImage imageNamed:[self currentShowImageName]];
    self.contents = (id)image.CGImage;
    
    CAKeyframeAnimation * layerTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    layerTransformAnim.values   = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -3, 0)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 3, 0)]];
    layerTransformAnim.keyTimes = @[@0,@0.4,@0.6,@1];
    layerTransformAnim.removedOnCompletion = NO;
    
    CAKeyframeAnimation * layerOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    layerOpacityAnim.values   = @[@0, @1,@1,@0];
    layerOpacityAnim.keyTimes = @[@0,@0.45,@0.55,@1];
    layerOpacityAnim.removedOnCompletion = NO;
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.animations = @[layerTransformAnim,layerOpacityAnim];
    groupAnimation.duration = 2.0;
    [self addAnimation:groupAnimation forKey:@"AnimationGroup"];
}

@end

@implementation HMGActivityIndicatorCycleSwitchImageAnimation

#pragma mark - Private Methods

- (CGFloat)angleWithDegress:(CGFloat)degress{
    return (M_PI * (degress) / 180.0);
}

- (CAShapeLayer *)addProgressLayerWithSize:(CGSize)size {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat radius = MIN(width, height)/2.0;
    layer.frame = CGRectMake(0, 0, width, height);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0, height/2.0) radius:radius startAngle:[self angleWithDegress:0] endAngle:[self angleWithDegress:360] clockwise:YES];
    layer.lineWidth = 2.0;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    return layer;
}

#pragma mark -
#pragma mark HMGActivityIndicatorAnimation Protocol

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(5, 5, size.width - 5*2, size.height - 5*2);
    backgroundLayer.backgroundColor = tintColor.CGColor;
    backgroundLayer.cornerRadius = (size.width - 5*2)/2.0;
    backgroundLayer.masksToBounds = YES;
    [layer addSublayer:backgroundLayer];
    
    HMGActivityIndicatorImageLayer *imageLayer = [HMGActivityIndicatorImageLayer layer];
    imageLayer.frame = CGRectMake(10, 10, size.width - 10*2, size.height - 10*2);
    imageLayer.anchorPoint = CGPointMake(0.5, 0.5);
    [layer addSublayer:imageLayer];
    [imageLayer startAnimation];
    
    CAShapeLayer *staticGradientShapeLayer = [CAShapeLayer layer];
    staticGradientShapeLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [layer addSublayer:staticGradientShapeLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(-5, -5, size.width + 10, size.height + 10);
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@0.5,@0.85];
    
    gradientLayer.colors = @[(id)tintColor.CGColor, (id)[UIColor clearColor].CGColor];
    [staticGradientShapeLayer addSublayer:gradientLayer];
    
    CAShapeLayer *progressLayer = [self addProgressLayerWithSize:size];
    staticGradientShapeLayer.mask = progressLayer;
    progressLayer.strokeColor = tintColor.CGColor;
    progressLayer.strokeEnd = 0.25;
    
    CAKeyframeAnimation *animation =  [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.autoreverses = NO;
    animation.values      = @[@(0), @( M_PI), @( 2 * M_PI)];
    animation.keyTimes    = @[@0, @0.5, @1];
    animation.duration    = 1;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = INT_MAX;
    animation.removedOnCompletion = NO;
    [staticGradientShapeLayer addAnimation:animation forKey:nil];
}

@end
