//
//  HMServiceAPI+Advertisement.h
//  AmazfitWatch
//
//  Created by 李宪 on 2018/6/1.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIAdvertisement;

typedef NS_ENUM(NSUInteger, HMServiceAPIAdvertisementType) {
    HMServiceAPIAdvertisementTypeHomeBanner,            // 首页横幅
    HMServiceAPIAdvertisementTypeHomePopup,             // 首页弹框
};




@protocol HMAdvertisementServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)advertisement_advertisementForType:(HMServiceAPIAdvertisementType)type
                                                   userID:(NSString *)userID
                                              addressCode:(NSString *)addressCode
                                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIAdvertisement>> *advertisements))completionBlock;


@end


@protocol HMServiceAPIAdvertisement <NSObject>

@property (readonly) NSString *api_advertisementID;
@property (readonly) NSString *api_advertisementTargetURL;
@property (readonly) NSString *api_advertisementTitle;
@property (readonly) NSString *api_advertisementImageURL;
@property (readonly) NSString *api_advertisementLogoURL;

@end



@interface HMServiceAPI (Advertisement) <HMAdvertisementServiceAPI>
@end
