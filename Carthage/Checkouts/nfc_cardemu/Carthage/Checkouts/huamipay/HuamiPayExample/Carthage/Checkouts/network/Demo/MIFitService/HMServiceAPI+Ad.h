//
//  HMServiceAPI+Ad.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceAPILaunchPageAdShareType) {
    HMServiceAPILaunchPageAdShareTypeNone,      // 不分享
    HMServiceAPILaunchPageAdShareTypeLink,      // 分享链接
    HMServiceAPILaunchPageAdShareTypeImage,     // 分享图片
};

typedef NS_ENUM(NSUInteger, HMServiceAPILaunchPageAdMediaType) {
    HMServiceAPILaunchPageAdMediaTypeImage,
    HMServiceAPILaunchPageAdMediaTypeGIF
};

@protocol HMServiceAPILaunchPageAd <NSObject>

@property (nonatomic, copy, readonly) NSString *api_launchPageAdID;
@property (nonatomic, strong, readonly) NSDate *api_launchPageAdStartTime;
@property (nonatomic, strong, readonly) NSDate *api_launchPageAdExpireTime;
@property (nonatomic, assign, readonly) NSUInteger api_launchPageAdSort;

@property (nonatomic, copy, readonly) NSString *api_launchPageAdTitle;
@property (nonatomic, assign, readonly) HMServiceAPILaunchPageAdMediaType api_launchPageAdMediaType;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdBackgroundImageURL;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdJumpURL;

@property (nonatomic, copy, readonly) NSString *api_launchPageAdProvince;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdCity;

@property (nonatomic, assign, readonly) HMServiceAPILaunchPageAdShareType api_launchPageAdShareType;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdShareTitle;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdShareSubtitle;
@property (nonatomic, copy, readonly) NSString *api_launchPageAdShareLink;

@property (nonatomic, copy, readonly) NSString *api_launchPageAdThirdPartyAppID;

@property (nonatomic, assign, readonly) BOOL api_launchPageAdShouldWriteCookie;
@property (nonatomic, assign, readonly) BOOL api_launchPageAdCanOpenViaGPRS;

@end


@protocol HMServiceAdAPI <HMServiceAPI>

/**
 开屏广告
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=111
 */
- (id<HMCancelableAPI>)ad_launchPageAdsWithCountry:(NSString *)country
                                          province:(NSString *)province
                                              city:(NSString *)city
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPILaunchPageAd>> *ads))completionBlock;

@end

@interface HMServiceAPI (Ad) <HMServiceAdAPI>
@end
