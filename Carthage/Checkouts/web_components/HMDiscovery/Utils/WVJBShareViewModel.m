//  WVJBShareViewModel.m
//  Created on 2018/5/18
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "WVJBShareViewModel.h"
#import "WVJBUtils.h"
#import <WebKit/WebKit.h>
@import HMLog;

@interface WVJBShareViewModel () <WVJBShareModelProtocol>

/** 分享的平台信息 */
@property (nonatomic, strong) NSDictionary *allPlatformsShareDict;
@property (nonatomic, strong) NSDictionary *shareDict;
@property (nonatomic, assign) BOOL isShareLink;
@property (nonatomic, assign) BOOL isJSBridgeShare;
@property (nonatomic, strong) NSString *currentURLString;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WVJBShareViewModel

- (void)dealloc {
    HMLogD(discovery, @"WVJBShareViewModel 释放了.");
}

- (void)configSharePlatform:(NSDictionary *)platformDict
                  isJBShare:(BOOL)isJBShare
                isShareLink:(BOOL)isShareLink
                 currentURL:(NSString *)currentURL
                    webView:(WKWebView *)webView{
    self.allPlatformsShareDict = platformDict;
    self.isShareLink = isShareLink;
    self.isJSBridgeShare = isJBShare;
    self.currentURLString = currentURL;
    self.webView = webView;
}

- (SSContentType)getShareContentTypeWithScene:(SSScene)shareScene {
    
    NSString *platform = [self getServersKeyWithShareScene:shareScene];
    if (self.isJSBridgeShare) {
        NSDictionary *especialDict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, @"especial");
        self.shareDict = DICT_ATTRIBUTE_FOR_KEY(especialDict, platform);
        if (!self.shareDict) {
            self.shareDict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, @"global");
        }
        NSString *shareType = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"type");
        if ([shareType isEqualToString:JSBridgeShareTypeCard]) {
            return SSContentTypeWebPage;
        } else if ([shareType isEqualToString:JSBridgeShareTypeImage]) {
            return SSContentTypeImage;
        } else {
            return SSContentTypeText;
        }
    } else {
        if (self.allPlatformsShareDict) {
            self.shareDict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, platform);
            if (!self.shareDict) {
                self.shareDict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, @"default");
            }
        }
        
        if (self.shareDict) {
            NSString *url = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"url");
            BOOL isShareWebPage = (url && url.length > 0) || self.isShareLink;
            return isShareWebPage ? SSContentTypeWebPage : SSContentTypeImage;
        }
        return SSContentTypeImage;
    }
}

- (NSData *)shareImageDataWithScene:(SSScene)shareScene {
    
    if (self.isJSBridgeShare) {
        NSString *capture = [NSString stringWithFormat:@"%@", DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"capture")];
        if ([capture isEqualToString:@"0"]) {
            NSString *serversKey = [self getServersKeyWithShareScene:shareScene];
            NSDictionary *dict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, @"especial");
            NSDictionary *shareDict = DICT_ATTRIBUTE_FOR_KEY(dict, serversKey);
            if (!shareDict) {
                shareDict = DICT_ATTRIBUTE_FOR_KEY(self.allPlatformsShareDict, @"global");
            }
            NSString *imageUrl = DICT_ATTRIBUTE_FOR_KEY(shareDict, @"imgUrl");
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            return UIImagePNGRepresentation([UIImage imageWithData:imageData]);
        } else if ([capture isEqualToString:@"1"]) {
            // 当前屏幕截图
            return UIImagePNGRepresentation([self getScreenshotWithView:self.webView.scrollView]);
        } else if ([capture isEqualToString:@"2"]) {
            // 截长图
            return UIImagePNGRepresentation([self getLongScreenshotWithView:self.webView.scrollView]);
        }
    } else {
        if (self.shareDict) {
            NSString *icon = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"icon");
            NSArray *parameters = [icon componentsSeparatedByString:@","];
            if (!parameters || parameters.count == 0) {
                return UIImagePNGRepresentation([self getScreenshotWithView:self.webView.scrollView]);
            }
            NSData *data = [[NSData alloc] initWithBase64EncodedString:[parameters lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (!data) {
                return UIImagePNGRepresentation([self getScreenshotWithView:self.webView.scrollView]);
            }
            return data;
        }
    }
    return UIImagePNGRepresentation([self getScreenshotWithView:self.webView.scrollView]);
}

- (id<WVJBShareModelProtocol>)getNativeShareInfo {
    return self;
}

#pragma mark - WVJBShareModelProtocol

- (NSString *)title {
    if (!self.shareDict) {
        return @"";
    }
    if (!self.isJSBridgeShare) {
        NSString *title = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"title");
        return title;
    }
    NSString *shareType = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"type");
    if ([shareType isEqualToString:JSBridgeShareTypeMix]) {
        NSString *title = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"desc");
        return title;
    } else if ([shareType isEqualToString:JSBridgeShareTypeText]) {
        NSString *title = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"title");
        NSString *desc = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"desc");
        return [NSString stringWithFormat:@"%@ %@", title, desc];
    } else{
        NSString *title = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, @"title");
        return title;
    }
}

- (NSString *)desc {
    NSString *key = self.isJSBridgeShare ? @"desc" : @"content";
    if (self.shareDict) {
        NSString *content = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, key);
        return content;
    }
    return @"";
}

- (NSString *)webpageUrl {
    NSString *key = self.isJSBridgeShare ? @"link" : @"url";
    if (self.shareDict) {
        NSString *url = DICT_ATTRIBUTE_FOR_KEY(self.shareDict, key);
        return url != nil ? url : @"";
    }
    return self.currentURLString;
}

# pragma mark - private funcs

- (NSString *)getServersKeyWithShareScene:(SSScene)shareScene {
    NSDictionary *shareKeyDict = @{@"weibo":@(SSSceneSina),
                                   @"weChat":@(SSSceneWXSession),
                                   @"moments":@(SSSceneWXTimeline),
                                   @"qq":@(SSSceneQQFrined),
                                   @"qzone":@(SSSceneQZone),
                                   @"facebook":@(SSSceneFacebook),
                                   @"twitter":@(SSSceneTwitter),
                                   };
    
    for (NSString *keyStr in shareKeyDict.allKeys) {
        NSInteger scene = [[shareKeyDict objectForKey:keyStr] integerValue];
        if (scene == shareScene) {
            return keyStr;
        }
    }
    return @"default";
}

- (UIImage *)getScreenshotWithView:(UIView *)view {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:true];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)getLongScreenshotWithView:(UIView *)view {
    if (![view isKindOfClass:[UIWebView class]]) {
        return [self getScreenshotWithView:view];
    }
    UIWebView *webView = (UIWebView *)view;
    CGSize totalSize = webView.scrollView.contentSize;
    CGFloat page = ceilf(totalSize.height / webView.bounds.size.height);
    NSInteger maxPage = 3;
    if (page > maxPage) {
        page = maxPage;
        totalSize = CGSizeMake(webView.bounds.size.width, page * webView.bounds.size.height);
    }
    UIGraphicsBeginImageContextWithOptions(totalSize, YES, [UIScreen mainScreen].scale);
    webView.scrollView.contentOffset = CGPointMake(0, 0);
    for (NSInteger index = 0; index < page; index++) {
        CGRect splitFrame = CGRectMake(0, index * webView.frame.size.height, webView.bounds.size.width, webView.frame.size.height);
        [webView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        webView.scrollView.contentOffset = CGPointMake(0, (index + 1) * webView.frame.size.height);
    }
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    webView.scrollView.contentOffset = CGPointMake(0, 0);
    return capturedImage;
}

- (void)refreshWebView {
    [self.webView reloadFromOrigin];
}
@end
