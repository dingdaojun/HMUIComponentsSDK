//
//  NSNumber+HMNetworkHTTPMethod.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSNumber+HMNetworkHTTPMethod.h"

#import "HMNetworkCore.h"

@implementation NSNumber (HMNetwork_HTTPMethod)

- (NSString *)hmn_HTTPMethodString {
    
    HMNetworkHTTPMethod method = self.unsignedIntegerValue;
    
    NSParameterAssert(method == HMNetworkHTTPMethodGET ||
                      method == HMNetworkHTTPMethodHEAD ||
                      method == HMNetworkHTTPMethodPOST ||
                      method == HMNetworkHTTPMethodPUT ||
                      method == HMNetworkHTTPMethodPATCH ||
                      method == HMNetworkHTTPMethodDELETE);
    
    switch (method) {
        case HMNetworkHTTPMethodGET: return @"GET";
        case HMNetworkHTTPMethodHEAD: return @"HEAD";
        case HMNetworkHTTPMethodPOST: return @"POST";
        case HMNetworkHTTPMethodPUT: return @"PUT";
        case HMNetworkHTTPMethodPATCH: return @"PATCH";
        case HMNetworkHTTPMethodDELETE: return @"DELETE";
    }
}

@end
