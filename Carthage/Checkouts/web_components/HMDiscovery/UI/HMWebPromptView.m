//  HMWebPromptView.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWebPromptView.h"
#import "WVJBCommon.h"
@import HMCategory;
@import Masonry;
@import HMLog;

#define resBundle   [NSBundle bundleForClass:[self class]]

@interface HMWebPromptView ()

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UIButton *checkNetAccessButton;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) id<WVJBBusinessProtocol> localize;

@end

@implementation HMWebPromptView

- (instancetype)initWithLocalize:(id<WVJBBusinessProtocol> __nullable)localize {
    self = [super init];
    if (self) {
        [self setupViews];
        self.localize = localize;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    HMLogD(discovery,@"HMWebPromptView 释放了.");
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithRGB:246 Green:247 Blue:248];
    self.reloadButton = [[UIButton alloc] init];
    self.reloadButton.backgroundColor = [UIColor colorWithRGB:246 Green:247 Blue:248];
    self.reloadButton.adjustsImageWhenHighlighted = NO;
    [self.reloadButton addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    self.promptImageView = [[UIImageView alloc] init];
    self.checkNetAccessButton = [[UIButton alloc] init];
    self.checkNetAccessButton.hidden = YES;
    self.checkNetAccessButton.backgroundColor = [UIColor whiteColor];
    self.checkNetAccessButton.layer.masksToBounds = YES;
    self.checkNetAccessButton.layer.cornerRadius = 20;
    self.checkNetAccessButton.layer.borderWidth = 1.0f;
    self.checkNetAccessButton.layer.borderColor = [UIColor colorWithHEXString:@"#000000" Alpha:0.2].CGColor;
    [self.checkNetAccessButton setTitleColor:[UIColor colorWithHEXString:@"#000000" Alpha:0.6] forState:UIControlStateNormal];
    [self.checkNetAccessButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.checkNetAccessButton setTitle:self.localize ? self.localize.checkNetwork_Field : @"检查网络" forState:UIControlStateNormal];
    [self.checkNetAccessButton addTarget:self action:@selector(openNetWorkSetting) forControlEvents:UIControlEventTouchUpInside];
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.font = [UIFont systemFontOfSize:12.0f];
    self.promptLabel.textColor = [UIColor colorWithHEXString:@"#000000" Alpha:0.2];
    [self addSubview:self.reloadButton];
    [self addSubview:self.promptImageView];
    [self addSubview:self.checkNetAccessButton];
    [self addSubview:self.promptLabel];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(@68);
        make.top.offset(244);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.promptImageView.mas_bottom).offset(12);
    }];
    [self.checkNetAccessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@118);
        make.height.mas_equalTo(@40);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.promptLabel.mas_bottom).offset(24);
    }];
}

- (void)hidden {
    self.hidden = YES;
    self.promptLabel.text = nil;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (void)showPromptWithType:(PromptType)promptType {
    switch (promptType) {
        case PromptTypeNoData:
            [self showPromptReloadHidden:YES checkNetBtnHidden:YES peomptText:self.localize ? self.localize.noData_Field : @"这里没有内容" imageName:@"discovery_loadPrompt"];
            break;
        case PromptTypeLoading:
            [self showPromptReloadHidden:YES checkNetBtnHidden:YES peomptText:self.localize ? self.localize.load_Field : @"加载中..." imageName:@"discovery_loadPrompt"];
            break;
        case PromptTypeLoadFail:
            [self showPromptReloadHidden:NO checkNetBtnHidden:YES peomptText:self.localize ? self.localize.loadFail_Field : @"加载失败，点击屏幕重试" imageName:@"discovery_loadPrompt"];
            break;
        case PromptTypeNoNetwork:
            [self showPromptReloadHidden:YES checkNetBtnHidden:YES peomptText:self.localize ? self.localize.noNetwork_Field : @"网络未连接，请检查后重试" imageName:@"discovery_loadPrompt"];
            break;
        case PromptTypeNoNetworkAccess:
            [self showPromptReloadHidden:YES checkNetBtnHidden:NO peomptText:self.localize ? self.localize.noAccess_Field : @"无网络连接权限，请检查设置" imageName:@"imgNoNetAccess"];
            break;
        default:
            break;
    }
}

- (void)showPromptReloadHidden:(BOOL)hidden
             checkNetBtnHidden:(BOOL)netHidden
                    peomptText:(NSString *)text
                     imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRGB:246 Green:247 Blue:248];
        self.userInteractionEnabled = YES;
        self.reloadButton.hidden = hidden;
        self.checkNetAccessButton.hidden = netHidden;
        self.promptImageView.image = [UIImage imageNamed:imageName];
        self.promptLabel.text = text;
    });
}

#pragma mark - private funcs

- (void)reloadWebView {
    [[NSNotificationCenter defaultCenter] postNotificationName:WEBLoadFail object:nil];
}

- (void)openNetWorkSetting {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}
@end
