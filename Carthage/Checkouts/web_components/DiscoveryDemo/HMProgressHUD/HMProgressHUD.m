//
//  HMProgressHUD.m
//  HMProgressHUD
//
//  Created by lilingang on 8/17/16.
//  Copyright © 2016 LiLingang. All rights reserved.
//

#import "HMProgressHUD.h"
#import "HMActivityIndicatorView.h"

//图片与文字中间间距
static CGFloat const HMProgressImageLabelVerticalMargin = 10.0;

/**@brief 定义了HUD显示的风格*/
typedef NS_ENUM(NSUInteger, HMProgressHUDType) {
    HMProgressHUDTypeInit,         /**初始值*/
    HMProgressHUDTypeLoading,      /**等待框*/
    HMProgressHUDTypeText,         /**纯文字*/
    HMProgressHUDTypeImage,        /**图片+文字*/
};

@interface HMProgressHUD ()

/**@brief HMProgressHUDType*/
@property (nonatomic, assign) HMProgressHUDType hudType;

/**@brief Window上的蒙层*/
@property (nonatomic, strong) UIView *overlayView;
/**@brief 提示框容器*/
@property (nonatomic, strong) UIView *hudView;
/**@brief 指示器*/
@property (nonatomic, strong) HMActivityIndicatorView *activityIndicatorView;
/**@brief 图片View*/
@property (nonatomic, strong) UIImageView *imageView;
/**@brief 提示文案*/
@property (nonatomic, strong) UILabel *statusLabel;

/**@brief showtext 和 showImage 消失定时器*/
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, copy) HMProgressHUDDismissCompletion completionBlock;

/**@brief statusLabel显示的是否是富文本，默认NO*/
@property (nonatomic, assign) BOOL isAttributedString;
/**@brief 元素水平方向边距, 默认20.0f*/
@property (nonatomic, assign) CGFloat itemsHorizontalMargin;
/**@brief 元素垂直方向边距, 默认20.0f*/
@property (nonatomic, assign) CGFloat itemsVerticalMargin;

//------------------UI Config

@property (nonatomic, assign) CGFloat minDismissDuration;
@property (nonatomic, assign) CGFloat maxDismissDuration;

@property (nonatomic, assign) HMProgressHUDMaskStyle maskStyle;
@property (nonatomic, assign) HMProgressHUDStyle hudStyle;
@property (nonatomic, strong) UIColor *maskColor;

@property (nonatomic, assign) CGFloat hudMinWidth;
@property (nonatomic, assign) CGFloat hudMaxWidth;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, assign) CGFloat hudCornerRadius;
@property (nonatomic, strong) UIColor *hudShadowColor;
@property (nonatomic, assign) CGSize hudShadowOffset;
@property (nonatomic, assign) CGFloat hudShadowRadius;


@property (nonatomic, assign) HMProgressHUDActivityType activityType;
@property (nonatomic, assign) HMProgressHUDActivityType lastActivityType;

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, assign) CGFloat labelLineSpacing;
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *activityColor;
@property (nonatomic, assign) CGFloat activitySize;

@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *errorImage;


//------------------NSLayoutConstraint
@property (nonatomic, strong) NSLayoutConstraint *hudViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *hudCenterYConstraint;

@property (nonatomic, strong) NSLayoutConstraint *indefiniteTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *indefiniteHeightConstraint;


@property (nonatomic, strong) NSLayoutConstraint *statusLabelTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *statusLabelWidthConstraint;

@end

@implementation HMProgressHUD

static CGFloat lastScreenWidth = 0;

+ (HMProgressHUD*)sharedView {
    static dispatch_once_t once;
    static HMProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        lastScreenWidth  = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    });
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    if (lastScreenWidth != screenWidth) {
        //fixbug 屏幕旋转导致显示位置不正确
        sharedView.frame = [[UIScreen mainScreen] bounds];
        lastScreenWidth = screenWidth;
    }
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;
        self.hudType = HMProgressHUDTypeInit;
        self.isAttributedString = NO;

        self.minDismissDuration = 1.5f;
        self.maxDismissDuration = 5.0f;
        
        self.itemsVerticalMargin = 20.0f;
        self.itemsHorizontalMargin = 20.0f;
        
        self.maskStyle = HMProgressHUDMaskStyleCustom;
        self.maskColor = [UIColor clearColor];
        self.hudStyle = HMProgressHUDStyleWhite;
        
        self.hudMinWidth = 101.0f;
        self.hudMaxWidth = 216.0f;
        
        self.hudCornerRadius = 4.0f;
        self.hudShadowOffset = CGSizeMake(3.0, 3.0);
        self.hudShadowRadius = 11.0;
        
        self.activityType = HMProgressHUDActivityTypeCycleSwitchImage;
        
        self.labelFont = [UIFont systemFontOfSize:14.0f];
        self.labelLineSpacing = 8.0f;
        
        _successImage = [[UIImage imageNamed:@"loading_icon_success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _errorImage = [[UIImage imageNamed:@"loading_icon_fail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return self;
}

#pragma mark - Public Methods

#pragma mark - UI Confige

+ (void)setDefaultMinDismissDuration:(CGFloat)minDismissDuration{
    [self sharedView].minDismissDuration = minDismissDuration;
}
+ (void)setDefaultMaxDismissDuration:(CGFloat)maxDismissDuration{
    [self sharedView].maxDismissDuration = maxDismissDuration;
}

+ (void)setDefaultMaskStyle:(HMProgressHUDMaskStyle)maskStyle{
    [self sharedView].maskStyle = maskStyle;
}
+ (void)setDefaultHUDStyle:(HMProgressHUDStyle)hudStyle {
    [self sharedView].hudStyle = hudStyle;
}

+ (void)setDefaultMaskColor:(UIColor *)color{
    [self sharedView].maskColor = color;
}


+ (void)setDefaultHUDBackGroudColor:(UIColor *)color{
    [self sharedView].hudBackgroundColor = color;
}
+ (void)setDefaultHUDCornerRadius:(CGFloat)cornerRadius{
    [self sharedView].hudCornerRadius = cornerRadius;
}
+ (void)setDefaultHUDShadowColor:(UIColor *)color{
    [self sharedView].hudShadowColor = color;
}
+ (void)setDefaultHUDShadowOffset:(CGSize)shadowOffset{
    [self sharedView].hudShadowOffset = shadowOffset;
}
+ (void)setDefaultHUDShadowRadius:(CGFloat)shadowRadius{
    [self sharedView].hudShadowRadius = shadowRadius;
}


+ (void)setDefaultActivityType:(HMProgressHUDActivityType)activityType{
    [self sharedView].activityType = activityType;
}
+ (void)setDefaultActivityColor:(UIColor *)activityColor{
    [self sharedView].activityColor = activityColor;
}
+ (void)setDefaultActivitySize:(CGFloat)activitySize{
    [self sharedView].activitySize = activitySize;
}


+ (void)setDefaultFont:(UIFont *)font{
    [self sharedView].labelFont = font;
}

+ (void)setDefaultTintColor:(UIColor *)tintColor{
    [self sharedView].tintColor = tintColor;
}

+ (void)setDefaultLineSpacing:(CGFloat)lineSpacing{
    [self sharedView].labelLineSpacing = lineSpacing;
}



+ (void)setDefaultSuccessImage:(UIImage *)image{
    [self sharedView].successImage = image;
}

+ (void)setDefaultErrorImage:(UIImage *)image{
    [self sharedView].errorImage = image;
}


#pragma mark - Show and Dismiss
+ (void)showHUDWithStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self sharedView].hudType == HMProgressHUDTypeLoading && [self sharedView].activityType == [self sharedView].lastActivityType) {
            [[self sharedView] updateStatus:status];
        } else {
            [self sharedView].lastActivityType = [self sharedView].activityType;
            [self sharedView].hudType = HMProgressHUDTypeLoading;
            [[self sharedView] showHUDStatus:status];
        }
    });
}

+ (void)showWithStatus:(NSString*)status{
    [self showWithStatus:status dismissCompletion:nil];
}

+ (void)showWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion{
    [self showImage:nil status:status dismissCompletion:completion];
}

+ (void)showSucessWithStatus:(NSString*)status{
    [self showSucessWithStatus:status dismissCompletion:nil];
}

+ (void)showSucessWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion{
    [self showImage:[self sharedView].successImage status:status dismissCompletion:completion];
}

+ (void)showErrorWithStatus:(NSString*)status{
    [self showErrorWithStatus:status dismissCompletion:nil];
}

+ (void)showErrorWithStatus:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion{
    [self showImage:[self sharedView].errorImage status:status dismissCompletion:completion];
}

+ (void)dismiss{
    [self dismissWithDelay:0 completion:nil];
}

+ (void)dismissWithCompletion:(HMProgressHUDDismissCompletion)completion{
    [self dismissWithDelay:0 completion:completion];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay{
    [self dismissWithDelay:delay completion:nil];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(HMProgressHUDDismissCompletion)completion{
    [[self sharedView] dismissWithDelay:delay completion:completion];
}

#pragma mark - Private Methods

- (void)updateUIStyle{
    if (self.hudStyle == HMProgressHUDStyleWhite) {
        self.hudBackgroundColor = [UIColor whiteColor];
        self.hudShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.24f];
        self.activityColor = [UIColor colorWithRed:132/255.0 green:146/255.0 blue:166/255.0 alpha:1.0f];
    } else {
        self.hudBackgroundColor = [UIColor blackColor];
        self.hudShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.82f];
        self.activityColor = [UIColor whiteColor];
    }
    self.activitySize = 24.0f;
    if (self.activityType == HMProgressHUDActivityTypeCycleSwitchImage) {
        self.activitySize = 42.0f;
    }
    self.tintColor = self.activityColor;
}

+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    CGFloat currentDuration = (float)string.length * 0.05;
    return MIN([self sharedView].maxDismissDuration, MAX([self sharedView].minDismissDuration, currentDuration));
}

+ (void)showImage:(UIImage *)image status:(NSString*)status dismissCompletion:(HMProgressHUDDismissCompletion)completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval duration = [self displayDurationForString:status];
        [self sharedView].hudType = image ? HMProgressHUDTypeImage : HMProgressHUDTypeText;
        [[self sharedView] showImage:image status:status duration:duration completion:completion];
    });
}

- (void)showHUDStatus:(NSString *)status{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelImageView];
    [self updateViewHierarchy];
    [self cancelActivityAnimation];
    [self updateUIStyle];
    
    if (!self.activityIndicatorView) {
        self.activityIndicatorView = [[HMActivityIndicatorView alloc] initWithType:self.activityType - 1];
        self.activityIndicatorView.size = self.activitySize;
        self.activityIndicatorView.frame = CGRectMake(0, 0, self.activitySize, self.activitySize);
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.hudView addSubview:self.activityIndicatorView];
        [self addLayoutConstraintsWithTopView:self.activityIndicatorView descriptionKey:@"activityIndicatorView" height:CGRectGetWidth(self.activityIndicatorView.bounds)];
    }
    self.activityIndicatorView.type = (NSUInteger)self.activityType;
    self.activityIndicatorView.tintColor = self.activityColor;
    [self.activityIndicatorView startAnimating];
    self.tintColor = self.activityColor;;
    [self showWithStatus:status];
}

- (void)showImage:(UIImage *)image status:(NSString *)status duration:(NSTimeInterval)duration completion:(HMProgressHUDDismissCompletion)completion{
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self cancelActivityAnimation];
    [self updateViewHierarchy];
    [self updateUIStyle];
    self.overlayView.userInteractionEnabled = NO;
    
    if (self.hudType == HMProgressHUDTypeImage) {
        if (!self.imageView) {
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32, 32)];
            self.imageView.backgroundColor = [UIColor clearColor];
            self.imageView.contentMode = UIViewContentModeCenter;
            self.imageView.translatesAutoresizingMaskIntoConstraints=NO;
            [self.hudView addSubview:self.imageView];
            [self addLayoutConstraintsWithTopView:self.imageView descriptionKey:@"imageView" height:CGRectGetWidth(self.imageView.bounds)];
            self.imageView.layer.cornerRadius = 16;
            self.imageView.layer.masksToBounds = YES;
        }
        self.imageView.tintColor = [UIColor whiteColor];
        self.imageView.backgroundColor = self.activityColor;
        self.imageView.image = image;
    } else {
        [self cancelImageView];
    }
    [self showWithStatus:status];
    [self dismissWithDelay:duration completion:completion];
}

#pragma mark - --------UI----------

- (void)updateViewHierarchy {
    if(!self.overlayView.superview) {
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) {
            NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
            for (UIWindow *window in frontToBackWindows) {
                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
                BOOL windowLevelSupported = window.windowLevel == UIWindowLevelNormal;
                if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
                    keyWindow = window;
                    break;
                }
            }
        }
        [keyWindow addSubview:self.overlayView];
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    if(!self.superview){
        [self.overlayView addSubview:self];
    }
    if(!self.hudView.superview) {
        [self addSubview:self.hudView];
        [self addHudViewLayoutConstraints];
    }
}

- (void)showWithStatus:(NSString*)status {
    [self updateStatus:status];
    __weak HMProgressHUD *weakSelf = self;
    __block void (^animationsBlock)(void) = ^{
        __strong HMProgressHUD *strongSelf = weakSelf;
        if(strongSelf) {
            strongSelf.alpha = 1.0f;
            strongSelf.hudView.alpha = 1.0f;
        }
    };
    CGFloat duration = 0;
    if (self.alpha != 1.0 || self.hudView.alpha != 1.0) {
        self.alpha = 0.0f;
        self.hudView.alpha = 0.0f;
        duration = 0.25;
    }
    [UIView transitionWithView:self.hudView
                      duration:duration
                       options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        animationsBlock();
                    } completion:^(BOOL finished) {
                    }];
}

- (void)updateStatus:(NSString *)status{
    CGFloat estimateStatusLabelHeight = [self calculateStatusLabelSizeWithString:status isAttributedString:NO].height;
    self.isAttributedString = estimateStatusLabelHeight - self.statusLabel.font.lineHeight >= 2.0;
    if (self.isAttributedString) {
        self.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:status attributes:[self statusTextAttributes:YES]];
    } else {
        self.statusLabel.text = status;
    }
    [self updateHUDFrame];
}

#pragma mark - Clear
- (void)cancelImageView{
    if (!self.imageView) {
        return;
    }
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;
    
    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;
    
    [self.imageView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.imageView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

- (void)cancelActivityAnimation{
    if (!self.activityIndicatorView) {
        return;
    }
    [self.hudView removeConstraint:self.indefiniteCenterXConstraint];
    self.indefiniteCenterXConstraint = nil;

    [self.hudView removeConstraint:self.indefiniteTopConstraint];
    self.indefiniteTopConstraint = nil;

    [self.activityIndicatorView removeConstraint:self.indefiniteWidthConstraint];
    self.indefiniteWidthConstraint = nil;
    
    [self.activityIndicatorView removeConstraint:self.indefiniteHeightConstraint];
    self.indefiniteHeightConstraint = nil;

    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
    self.activityIndicatorView = nil;
}

- (void)clearAll{
    self.hudType = HMProgressHUDTypeInit;
    self.isAttributedString = NO;

    [self cancelImageView];
    [self cancelActivityAnimation];
    
    [self removeConstraint:self.hudCenterXConstraint];
    self.hudCenterXConstraint = nil;
    [self removeConstraint:self.hudCenterYConstraint];
    self.hudCenterYConstraint = nil;
    
    [self.hudView removeConstraint:self.hudViewWidthConstraint];
    self.hudViewWidthConstraint = nil;
    [self.hudView removeConstraint:self.hudViewHeightConstraint];
    self.hudViewHeightConstraint = nil;

    
    [self.hudView removeConstraint:self.statusLabelCenterXConstraint];
    self.statusLabelCenterXConstraint = nil;
    [self.hudView removeConstraint:self.statusLabelTopConstraint];
    self.statusLabelTopConstraint = nil;
    [self.statusLabel removeConstraint:self.statusLabelHeightConstraint];
    self.statusLabelHeightConstraint = nil;
    [self.statusLabel removeConstraint:self.statusLabelWidthConstraint];
    self.statusLabelWidthConstraint = nil;
    [self.statusLabel removeFromSuperview];
    self.statusLabel = nil;

    [self.hudView removeFromSuperview];
    self.hudView = nil;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    [self removeFromSuperview];
}

#pragma mark - ----------Frame

- (CGSize)calculateStatusLabelSizeWithString:(NSString *)string isAttributedString:(BOOL)isAttributedString{
    if (!string || [string length] == 0) {
        return CGSizeZero;
    }
    CGSize constraintSize = CGSizeMake(self.hudMaxWidth - 2*self.itemsHorizontalMargin, CGFLOAT_MAX);
    CGRect stringRect = [string boundingRectWithSize:constraintSize
                                             options:
                         NSStringDrawingUsesFontLeading|
                         NSStringDrawingTruncatesLastVisibleLine|
                         NSStringDrawingUsesLineFragmentOrigin
                                          attributes:[self statusTextAttributes: isAttributedString]
                                             context:NULL];
    return stringRect.size;
}

- (void)updateHUDFrame {
    CGSize statusLabelSize = [self calculateStatusLabelSizeWithString:self.statusLabel.text isAttributedString:self.isAttributedString];
    CGFloat verticalMarginSpace = self.itemsVerticalMargin;
    self.statusLabelTopConstraint.constant = 0;
    if (self.hudType == HMProgressHUDTypeLoading ||
        self.hudType == HMProgressHUDTypeImage) {
        self.statusLabelTopConstraint.constant += self.indefiniteTopConstraint.constant + self.indefiniteHeightConstraint.constant + HMProgressImageLabelVerticalMargin;
    } else {
        self.statusLabelTopConstraint.constant += verticalMarginSpace;
    }
    self.statusLabelHeightConstraint.constant = ceil(statusLabelSize.height);
    self.statusLabelWidthConstraint.constant = MAX(self.hudMinWidth - 2*self.itemsHorizontalMargin, ceil( statusLabelSize.width));
    
    self.hudViewWidthConstraint.constant = self.statusLabelWidthConstraint.constant + 2*self.itemsHorizontalMargin;
    self.hudViewHeightConstraint.constant = self.statusLabelTopConstraint.constant + self.statusLabelHeightConstraint.constant + verticalMarginSpace;
}

#pragma mark - -----------TextAttribute
- (NSDictionary *)statusTextAttributes:(BOOL)hasLineSpace{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = hasLineSpace ? self.labelLineSpacing : 0;
    paragraphStyle.maximumLineHeight = self.labelFont.lineHeight;
    paragraphStyle.minimumLineHeight = self.labelFont.lineHeight;
    paragraphStyle.alignment = hasLineSpace ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.statusLabel.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}

#pragma mark - dismiss

- (void)dismissWithDelay:(NSTimeInterval)delay completion:(HMProgressHUDDismissCompletion)completion {
    self.completionBlock = completion;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fadeOutTimer) {
            [self.fadeOutTimer invalidate];
            self.fadeOutTimer = nil;
        }
        self.fadeOutTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)dismiss{
    __weak HMProgressHUD *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),^{
        __strong HMProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            __block void (^animationsBlock)(void) = ^{
                strongSelf.alpha = 0.0f;
                strongSelf.hudView.alpha = 0.0f;
            };
            __block void (^completionBlock)(void) = ^{
                if(strongSelf.alpha == 0.0f && strongSelf.hudView.alpha == 0.0f){
                    [strongSelf clearAll];
                    if (strongSelf.completionBlock) {
                        strongSelf.completionBlock();
                        strongSelf.completionBlock = nil;
                    }
                }
            };
            [UIView transitionWithView:strongSelf.hudView
                              duration:0.25
                               options:UIViewAnimationOptionAllowUserInteraction |
             UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                            animations:^{
                                animationsBlock();
                            } completion:^(BOOL finished) {
                                completionBlock();
                            }];
        } else if (strongSelf.completionBlock){
            strongSelf.completionBlock();
            strongSelf.completionBlock = nil;
        }
        
    });
}

#pragma mark - NSLayoutConstraint
- (void)addHudViewLayoutConstraints{
    NSDictionary* views = @{@"hudView":self.hudView};

    self.hudViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hudView(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.hudViewWidthConstraint];
    
    self.hudViewHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hudView(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.hudViewHeightConstraint];
    
    self.hudCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.hudView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:self.hudCenterYConstraint];
    NSLayoutConstraint *hudCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.hudView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:hudCenterXConstraint];
    self.hudCenterXConstraint = hudCenterXConstraint;
}

- (void)addLayoutConstraintsWithTopView:(id)view descriptionKey:(NSString *)descriptionKey height:(CGFloat)height{
    NSDictionary* views = @{descriptionKey:view};
    NSLayoutConstraint *indefiniteViewTopConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:self.itemsVerticalMargin];
    [self.hudView addConstraint:indefiniteViewTopConstraint];
    self.indefiniteTopConstraint = indefiniteViewTopConstraint;
    
    NSLayoutConstraint *indefiniteViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.hudView addConstraint:indefiniteViewCenterXConstraint];
    self.indefiniteCenterXConstraint = indefiniteViewCenterXConstraint;
    
    NSString *widthVisualFormat = [NSString stringWithFormat:@"H:[%@(%f)]",descriptionKey,height];
    NSLayoutConstraint *indefiniteViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:widthVisualFormat options:0 metrics:nil views:views] firstObject];
    [view addConstraint:indefiniteViewWidthConstraint];
    self.indefiniteWidthConstraint = indefiniteViewWidthConstraint;
    
    NSString *heightVisualFormat = [NSString stringWithFormat:@"V:[%@(%f)]",descriptionKey,height];
    NSLayoutConstraint *indefiniteViewHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:heightVisualFormat options:0 metrics:nil views:views] firstObject];
    [view addConstraint:indefiniteViewHeightConstraint];
    self.indefiniteHeightConstraint = indefiniteViewHeightConstraint;
}

- (void)addStatusLabelLayoutConstraints{
    NSDictionary* views = @{@"statusLabel":self.statusLabel};
    self.statusLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeTop multiplier:1 constant:self.itemsVerticalMargin];
    [self.hudView addConstraint:self.statusLabelTopConstraint];
    
    self.statusLabelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.hudView addConstraint:self.statusLabelCenterXConstraint];
    
    self.statusLabelWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[statusLabel(100)]" options:0 metrics:nil views:views] firstObject];
    [self.hudView addConstraint:self.statusLabelWidthConstraint];
    
    self.statusLabelHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusLabel(14)]" options:0 metrics:nil views:views] firstObject];
    [self.statusLabel addConstraint:self.statusLabelHeightConstraint];
}

#pragma mark - Getter And Setter

- (UIView*)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.bounds];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if (self.maskStyle == HMProgressHUDMaskStyleCustom){
        _overlayView.backgroundColor = self.maskColor;
        _overlayView.userInteractionEnabled = YES;
    } else {
        _overlayView.backgroundColor = [UIColor clearColor];
        _overlayView.userInteractionEnabled = NO;
    }
    return _overlayView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.translatesAutoresizingMaskIntoConstraints=NO;
        _hudView.layer.shadowOpacity = 1.0;
    }
    _hudView.backgroundColor = self.hudBackgroundColor;
    _hudView.layer.shadowOffset = self.hudShadowOffset;
    _hudView.layer.shadowRadius = self.hudShadowRadius;
    _hudView.layer.cornerRadius = self.hudCornerRadius;
    _hudView.layer.shadowColor = self.hudShadowColor.CGColor;
    return _hudView;
}

- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        _statusLabel.translatesAutoresizingMaskIntoConstraints=NO;
    }
    if(!_statusLabel.superview) {
        [self.hudView addSubview:_statusLabel];
        [self addStatusLabelLayoutConstraints];
    }
    _statusLabel.textColor = self.tintColor;
    _statusLabel.font = self.labelFont;
    return _statusLabel;
}

@end
