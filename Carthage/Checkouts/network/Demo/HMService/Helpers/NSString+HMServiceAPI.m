//
//  NSString+HMServiceAPI.h.m
//  HMNetworkLayer
//
//  Created by 李宪 on 9/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSString+HMServiceAPI.h"

@implementation NSString (HMServiceAPIURLEncode)

- (NSString *)hms_stringByEncodingPercentEscape {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

- (NSString *)hms_stringByDecodingPercentEscape {
    
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
