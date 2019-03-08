//
//  HMServiceAPITask.h
//  HMNetworkLayer
//
//  Created by 李宪 on 10/7/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMServiceAPI.h"

@class NSURLSessionTask;

typedef NSURLSessionTask *(^HMServiceAPIConcreteBlock)(void);


@interface HMServiceAPITask : NSObject <HMCancelableAPI>

+ (instancetype)taskWithConcreteBlock:(HMServiceAPIConcreteBlock)block;

@end
