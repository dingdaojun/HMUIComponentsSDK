//  HMWebPromptView.h
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <UIKit/UIKit.h>
#import "WVJBBusinessProtocol.h"

typedef NS_ENUM(NSInteger, PromptType) {
    PromptTypeLoading = 0,      //加载
    PromptTypeNoData,           //无数据
    PromptTypeNoNetwork,        //无网络
    PromptTypeLoadFail,         //加载失败
    PromptTypeNoNetworkAccess,  //无网络权限
};

@interface HMWebPromptView : UIView

- (instancetype)initWithLocalize:(id<WVJBBusinessProtocol> __nullable)localize;
- (void)hidden;
- (void)showPromptWithType:(PromptType)promptType;

@end
