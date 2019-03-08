//
//  NSTimeZone+HMServiceAPI.h
//  HMNetworkLayer
//
//  Created by 李宪 on 2/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimeZone (HMServiceAPI)

- (NSInteger)hms_offset;
+ (instancetype)hms_timeZoneWithOffset:(NSInteger)offset;

@end
