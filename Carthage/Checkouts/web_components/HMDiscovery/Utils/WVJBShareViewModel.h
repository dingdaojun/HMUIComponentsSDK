//  WVJBShareViewModel.h
//  Created on 2018/5/18
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WVJBCommon.h"
@class WKWebView;

@protocol WVJBShareModelProtocol <NSObject>

/** 标题 */
@property (nonatomic, readonly) NSString *title;
/** 描述 */
@property (nonatomic, readonly) NSString *desc;
/** 分享的URL */
@property (nonatomic, readonly) NSString *webpageUrl;

@end

@interface WVJBShareViewModel : NSObject

/**
 配置分享信息

 @param platformDict 各个平台分享信息
 @param isJBShare 是否是JBShare
 @param isShareLink 是否分享链接
 @param currentURL 当前页面请求的URL
 @param webView 展示的webView
 */
- (void)configSharePlatform:(NSDictionary *)platformDict
                  isJBShare:(BOOL)isJBShare
                isShareLink:(BOOL)isShareLink
                 currentURL:(NSString *)currentURL
                    webView:(WKWebView *)webView;

/**
 分享内容类型

 @param shareScene 分享的平台
 @return ContentType
 */
- (SSContentType)getShareContentTypeWithScene:(SSScene)shareScene;

/**
 当前分享页面的截图
 
 @param shareScene 分享平台
 @return NSData for Image
 */
- (NSData *)shareImageDataWithScene:(SSScene)shareScene;

/**
 提供给Native 分享视图的信息

 @return ShareModel
 */
- (id<WVJBShareModelProtocol>)getNativeShareInfo;

/**
 刷新页面内容(截图需要)
 */
- (void)refreshWebView;

@end
