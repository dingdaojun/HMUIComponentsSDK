//
//  HMServiceAPI+Statistic.h
//  HuamiWatch
//
//  Created by 李宪 on 28/8/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMStatisticServiceAPI <NSObject>

- (id<HMCancelableAPI>)statistic_recordBecameActiveWithDeviceID:(NSString *)deviceID
                                                watchRomVersion:(NSString *)watchRomVersion
                                                watchMACAddress:(NSString *)watchMACAddress
                                              watchSerialNumber:(NSString *)watchSerialNumber
                                                completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end


@interface HMServiceAPI (Statistic) <HMStatisticServiceAPI>
@end
