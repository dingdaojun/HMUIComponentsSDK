//
//  HMServiceAPI+LegacyHandleResult.h
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"

@interface HMServiceAPI (LegacyHandleResult)

- (void)legacy_handleResultForAPI:(SEL)API
                    responseError:(NSError *)responseError
                         response:(NSURLResponse *)response
                   responseObject:(NSDictionary *)responseObject
                  completionBlock:(void (^)(BOOL success, NSString *message, id data))completionBlock;

@end
