//
//  NSString+HMServiceAPI.h.h
//  HMNetworkLayer
//
//  Created by 李宪 on 9/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMServiceAPIURLEncode)

- (NSString *)hms_stringByEncodingPercentEscape;
- (NSString *)hms_stringByDecodingPercentEscape;

@end
