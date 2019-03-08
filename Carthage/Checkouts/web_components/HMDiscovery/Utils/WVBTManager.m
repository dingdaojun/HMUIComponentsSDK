//  WVBTManager.m
//  Created on 2018/5/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "WVBTManager.h"
@import HMLog;

@interface WVBTManager()

@property (nonatomic, strong) NSDictionary *braceletDict;

@end

@implementation WVBTManager

- (instancetype)init {
    if (self = [super init]) {
        
        NSDictionary *braceletDict =
        @{ @"bracelet://cn.com.hm.health/bind" : @(HMHtmlBracelet_Bind),
           @"bracelet://cn.com.hm.health/set_right_button" : @(HMHtmlBracelet_SetRightButtonVisible),
           @"bracelet://cn.com.hm.health/set_title_content" : @(HMHtmlBracelet_SetTitleContent),
           @"bracelet://cn.com.hm.health/set_title_bgd_color" : @(HMHtmlBracelet_SetNavigationBgColor),
           @"bracelet://cn.com.hm.health/set_back_button" : @(HMHtmlBracelet_SetBackButtonAction),
           @"bracelet://cn.com.hm.health/action" : @(HMHtmlBracelet_Action),
           @"bracelet://cn.com.hm.health/share" : @(HMHtmlBracelet_Share),
           @"bracelet://cn.com.hm.health/share_button" : @(HMHtmlBracelet_ShareButton),
           @"bracelet://cn.com.hm.health/set_title_visible" : @(HMHtmlBracelet_SetNavigationVisible),
           @"bracelet://cn.com.hm.health/exit" : @(HMHtmlBracelet_ExitHtmlWebView),
           @"bracelet://cn.com.hm.health/set_status_bar_color" : @(HMHtmlBracelet_SetStatusBarColor),
           @"bracelet://cn.com.hm.health/check_app_installed" : @(HMHtmlBracelet_CheckAppInstalled),
           @"bracelet://cn.com.hm.health/relogin" : @(HMHtmlBracelet_Relogin),
           @"bracelet://cn.com.hm.health/login" : @(HMHtmlBracelet_Login),
           @"bracelet://cn.com.hm.health/invalid_login" : @(HMHtmlBracelet_InvalidLogin),
           @"bracelet://cn.com.hm.health/set_left_button" : @(HMHtmlBracelet_SetLeftButton),
           @"bracelet://cn.com.hm.health/open_in_browser" : @(HMHtmlBracelet_OpenInBrowser),
           };
        self.braceletDict = braceletDict;
    }
    return self;
}

- (void)dealloc {
    HMLogD(discovery,@"WVBTManager 释放了.");
}

- (void)setHtmlBraceletTypeWithRequestString:(NSString *)requestString {
    if ([requestString length] == 0) {
        return;
    }
    
    NSString *protocolString;
    NSRange range = [requestString rangeOfString:@"?"];
    if (range.location != NSNotFound && range.length > 0) {
        protocolString = [requestString substringToIndex:range.location];
    } else {
        protocolString = requestString;
    }
    
    HMHtmlBraceletType braceleType = HMHtmlBracelet_None;
    
    if (protocolString) {
        NSNumber *protocolType = self.braceletDict[protocolString];
        if (protocolType) {
            braceleType = (HMHtmlBraceletType)[protocolType integerValue];
        }
    }
    
    [self startHtmlProtocolRequestWirhString:requestString BraceleType:braceleType];
}

- (void)startHtmlProtocolRequestWirhString:(NSString *)requestString BraceleType:(HMHtmlBraceletType)braceleType {
    NSRange range = [requestString rangeOfString:@"?"];
    NSString *parameterString = nil;
    if (range.location != NSNotFound && range.length > 0) {
        if (requestString.length > range.location + 1) {
            parameterString = [requestString substringFromIndex:range.location + 1];
            NSDictionary *braceletDict = [self getBraceletDictWithParameterString:parameterString];
            if (self.delegate) {
                [self.delegate braceletManagerDict:braceletDict braceletType:braceleType];
            }
        }
    } else {
        if (self.delegate) {
            [self.delegate braceletManagerDict:@{ @"braceleType" : @(braceleType) } braceletType:braceleType];
        }
    }
}

- (NSDictionary *)getBraceletDictWithParameterString:(NSString *)parameterString {
    if ([parameterString length] == 0) {
        return nil;
    }
    NSMutableDictionary *braceletDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSArray *array = [parameterString componentsSeparatedByString:@"&"];
    if ([array count] == 0) {
        return nil;
    }
    for (NSString *str in array) {
        NSArray *parameters = [str componentsSeparatedByString:@"="];
        if ([parameters count] == 2) {
            NSString *key = [parameters firstObject];
            NSString *valueStr = [parameters lastObject];
            if (valueStr && key) {
                [braceletDict setObject:valueStr forKey:key];
            }
        } else if ([parameters count] > 2) {
            NSMutableString *string = [[NSMutableString alloc] init];
            for (NSInteger index=1; index<parameters.count; index++) {
                [string appendString:[NSString stringWithFormat:@"=%@", parameters[index]]];
            }
            NSString *encodedString;
            if (string.length > 1) {
                NSRange range = NSMakeRange(1, string.length-1);
                encodedString = [string substringWithRange:range];
            }
            id objKey = [parameters firstObject];
            if (encodedString && objKey) {
                [braceletDict setObject:encodedString forKey:objKey];
            }
        }
    }
    return braceletDict;
}
@end
