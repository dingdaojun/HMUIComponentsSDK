//
//  HMServiceAPI+AGPS.h
//  HuamiWatch
//
//  Created by dingdaojun on 2017/8/1.
//  Copyright © 2017年 Huami. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIAGPS <NSObject>

@property (readonly) NSString *api_AGPSFileType;
@property (readonly) NSString *api_AGPSFileURL;
@property (readonly) NSUInteger api_AGPSDays;

@end

@protocol HMServiceAPIBEP <NSObject>

@property (readonly) NSString *api_BEPFileType;
@property (readonly) NSString *api_BEPFileURL;

@end

@protocol HMAGPSServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)agps_retrieveAGPSFileInfoWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIAGPS>agps))completionBlock;

- (id<HMCancelableAPI>)agps_retrieveBEPFileInfoWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIBEP>bep))completionBlock;
@end

@interface HMServiceAPI (AGPS) <HMAGPSServiceAPI>
@end
