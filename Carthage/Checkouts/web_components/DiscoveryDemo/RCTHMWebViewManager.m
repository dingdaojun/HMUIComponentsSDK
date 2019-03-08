//  RCTHMWebViewManager.m
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "RCTHMWebViewManager.h"
#import "RCTHMWebView.h"

@implementation RCTHMWebViewManager

RCT_EXPORT_MODULE();
@synthesize bridge = _bridge;

- (UIView *)view {
    return [[RCTHMWebView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(isJSBridgeNeedAuth, BOOL);
RCT_EXPORT_VIEW_PROPERTY(scalesPageToFit, BOOL);
RCT_EXPORT_VIEW_PROPERTY(sourceURL, NSString);

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
