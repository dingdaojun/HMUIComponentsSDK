//
//  HMServiceAPI+HandleResult.h
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI.h"

typedef NS_ENUM(NSUInteger, HMServiceResultDataFormat) {
    HMServiceResultDataFormatAny,
    HMServiceResultDataFormatDictionary,
    HMServiceResultDataFormatArray,
};

@interface HMServiceAPI (HandleResult)

- (void)handleResultForAPI:(SEL)API
             responseError:(NSError *)responseError
                  response:(NSURLResponse *)response
            responseObject:(id)responseObject
         desiredDataFormat:(HMServiceResultDataFormat)dataFormat
           completionBlock:(void (^)(BOOL success, NSString *message, id data))completionBlock;

@end
