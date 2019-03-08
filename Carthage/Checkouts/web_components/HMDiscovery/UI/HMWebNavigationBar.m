//  HMWebNavigationBar.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWebNavigationBar.h"
@import HMCategory;
@import Masonry;
@import ReactiveObjC;
@import HMLog;

#define resBundle       [NSBundle bundleForClass:[self class]]

@interface HMWebNavigationBar ()

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIView *navigationView;

@end

@implementation HMWebNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAllViews];
    }
    return self;
}

- (void)dealloc {
    HMLogD(discovery,@"HMWebNavigationBar 释放了.");
}

- (void)setupAllViews {
    UIColor *backColor = [UIColor colorWithRGB:238 Green:239 Blue:240];
    self.backgroundColor = backColor;
    self.statusView = [[UIView alloc] init];
    self.statusView.backgroundColor = backColor;
    self.navigationView = [[UIView alloc] init];
    self.navigationView.backgroundColor = backColor;
    [self addSubview:self.statusView];
    [self addSubview:self.navigationView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHEXString:@"#000000" Alpha:0.7];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backButton = [[UIButton alloc] init];
    [self.backButton setContentMode:UIViewContentModeCenter];
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setContentMode:UIViewContentModeCenter];
    self.moreButton = [[UIButton alloc] init];
    [self.moreButton setContentMode:UIViewContentModeCenter];
    self.authorizeButton = [[UIButton alloc] init];
    [self.authorizeButton setContentMode:UIViewContentModeCenter];
    [self.navigationView addSubview:self.titleLabel];
    [self.navigationView addSubview:self.backButton];
    [self.navigationView addSubview:self.closeButton];
    [self.navigationView addSubview:self.moreButton];
    [self.navigationView addSubview:self.authorizeButton];
    
    [self setupAllButtonImagesWithTintColor:nil];
    
    CGFloat statusHeight = [UIDevice isPhoneXDevice] ? 44.0f : 20.0f;
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(statusHeight));
        make.top.left.right.equalTo(self);
    }];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@44);
        make.top.equalTo(self.statusView.mas_bottom);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@44);
        make.left.bottom.equalTo(self);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@44);
        make.left.equalTo(self.backButton.mas_right);
        make.bottom.equalTo(self);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@44);
        make.right.bottom.equalTo(self);
    }];
    [self.authorizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@44);
        make.bottom.equalTo(self);
        make.right.equalTo(self.moreButton.mas_left);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(@44);
        make.width.mas_lessThanOrEqualTo(@160);
    }];
    
    [self addRACObservers];
}

- (void)setupAllButtonImagesWithTintColor:(UIColor *)color {
    int scaleInt = [[UIScreen mainScreen] scale];
    NSString *backImgPath = [NSString stringWithFormat:@"btn_back_18@%dx.png",scaleInt];
    NSString *closeImgPath = [NSString stringWithFormat:@"btn_close_18@%dx.png",scaleInt];
    NSString *authImgPath = [NSString stringWithFormat:@"btn_cancel_auth@%dx.png",scaleInt];
    NSString *moreImgPath = [NSString stringWithFormat:@"btn_more_18@%dx.png",scaleInt];
    
    UIImage *backImg = [UIImage imageWithContentsOfFile:[resBundle pathForResource:backImgPath ofType:nil]];
    UIImage *closeImg = [UIImage imageWithContentsOfFile:[resBundle pathForResource:closeImgPath ofType:nil]];
    UIImage *authImg = [UIImage imageWithContentsOfFile:[resBundle pathForResource:authImgPath ofType:nil]];
    UIImage *moreImg = [UIImage imageWithContentsOfFile:[resBundle pathForResource:moreImgPath ofType:nil]];
    
    UIColor *defalutColor = [UIColor colorWithRGB:153 Green:153 Blue:153];
    UIColor *tintColor = color ? color : defalutColor;
    [self.backButton setImage:[backImg imageWithTintColor:tintColor] forState:UIControlStateNormal];
    [self.closeButton setImage:[closeImg imageWithTintColor:tintColor] forState:UIControlStateNormal];
    [self.authorizeButton setImage:[authImg imageWithTintColor:tintColor] forState:UIControlStateNormal];
    [self.moreButton setImage:[moreImg imageWithTintColor:tintColor] forState:UIControlStateNormal];
}

- (void)addRACObservers {
    
    // 返回按钮事件
    @weakify(self);
    self.backButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *backButtonActionDict = @{ @"key" : self.backButtonActionKey ? self.backButtonActionKey : @"",
                                                    @"url" : self.backButtonActionUrl ? self.backButtonActionUrl : @"", };
            [subscriber sendNext:backButtonActionDict];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (void)setIsShowMoreButton:(BOOL)isShowMoreButton {
    _isShowMoreButton = isShowMoreButton;
    self.moreButton.hidden = !isShowMoreButton;
}

- (void)setIsShowCloseButton:(BOOL)isShowCloseButton {
    _isShowCloseButton = isShowCloseButton;
    self.closeButton.hidden = !isShowCloseButton;
}

- (void)setIsShowAuthorizeButton:(BOOL)isShowAuthorizeButton {
    _isShowAuthorizeButton = isShowAuthorizeButton;
    self.authorizeButton.hidden = !isShowAuthorizeButton;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (!titleColor) {
        return;
    }
    self.titleLabel.textColor = titleColor;
    [self setupAllButtonImagesWithTintColor:titleColor];
}

- (void)setNavigationVisible:(BOOL)navigationVisible {
    HMLogD(discovery, @"navigationVisible display: %d",navigationVisible);
    _navigationVisible = navigationVisible;
    [self.navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(navigationVisible ? 44.0f : 0);
    }];
    self.navigationView.hidden = !navigationVisible;
}

- (void)setStatusColor:(UIColor *)statusColor {
    _statusColor = statusColor;
    self.statusView.backgroundColor = statusColor;
    self.navigationView.backgroundColor = statusColor;
}
@end
