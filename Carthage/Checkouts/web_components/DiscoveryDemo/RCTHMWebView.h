//  RCTHMWebView.h
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTDefines.h>
#import <React/RCTConvert.h>

@interface RCTHMWebView : UIView

@property (nonatomic, assign) BOOL isJSBridgeNeedAuth;
@property (nonatomic, assign) BOOL scalesPageToFit;
@property (nonatomic, strong) NSString *sourceURL;

@end
