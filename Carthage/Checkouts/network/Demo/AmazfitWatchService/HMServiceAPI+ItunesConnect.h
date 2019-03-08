//
//  HMServiceAPI+AppItunesConnectService.h
//  AmazfitWatch
//
//  Created by 刘星 on 2017/12/12.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIAppItunesConnectData <NSObject>

@property (readonly) NSString *api_appItunesConnectIcon;
@property (readonly) NSString *api_appItunesConnectName;

@end


@protocol HMServiceItunesConnectAPI <HMServiceAPI>

- (id<HMCancelableAPI>)itunesConnect_iconWithBundleID:(NSString *)bundleId completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIAppItunesConnectData>> *appItunesConnect))completionBlock;

@end

@interface HMServiceAPI (ItunesConnect) <HMServiceItunesConnectAPI>

@end
