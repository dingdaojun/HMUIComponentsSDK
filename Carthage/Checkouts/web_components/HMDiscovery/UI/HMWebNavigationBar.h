//  HMWebNavigationBar.h
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <UIKit/UIKit.h>

@interface HMWebNavigationBar : UIView

@property (nonatomic, copy) NSString *backButtonActionKey;
@property (nonatomic, copy) NSString *backButtonActionUrl;

@property (nonatomic, assign) BOOL isShowCloseButton;
@property (nonatomic, assign) BOOL isShowMoreButton;
@property (nonatomic, assign) BOOL isShowAuthorizeButton;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *statusColor;
@property (nonatomic, assign) BOOL navigationVisible;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *authorizeButton;

@end
