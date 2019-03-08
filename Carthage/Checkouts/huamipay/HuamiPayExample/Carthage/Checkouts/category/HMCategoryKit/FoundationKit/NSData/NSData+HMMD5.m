//
//  NSData+HMMD5.m
//  Pods
//
//  Created by 李宪 on 7/8/2017.
//
//

#import "NSData+HMMD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (MD5)


#pragma mark md5
- (NSString *)md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)self.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
