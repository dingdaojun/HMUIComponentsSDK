//
//  HMServiceAPI+Watchface.h
//  AmazfitWatch
//
//  Created by hongzhiqiang on 2018/5/2.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMWatchFaceServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)watchface_queryWatchfaceInfo:(NSString *)serviceName
                                    completionBlock:(void(^)(BOOL success, NSString *imageUrl, NSString *title))block;

@end


@interface HMServiceAPI (Watchface) <HMWatchFaceServiceAPI>
@end
