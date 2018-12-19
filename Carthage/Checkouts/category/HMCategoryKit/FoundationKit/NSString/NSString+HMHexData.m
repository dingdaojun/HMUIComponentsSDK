//
//  NSString+HMHexData.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/9.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "NSString+HMHexData.h"


static NSInteger macAddressLength = 12;


@implementation NSString (HMHexData)


#pragma mark 转成NSData
- (NSData *)toDataForHexString {
    NSString *hexString = self;
    
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    
    for (int i = 0; i < ([hexString length] / 2); i++) {
        byte_chars[0] = [hexString characterAtIndex:i * 2];
        byte_chars[1] = [hexString characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    return data;
}

#pragma mark 格式化mac地址，ex: 00:00:00:00:00:00
- (NSString *)formatPeripheralMacAddress {
    NSString *retVal = self;
    
    if (self.length == macAddressLength) {
        NSString *idStr = [self copy];
        retVal = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
                  [idStr substringWithRange:NSMakeRange(0, 2)],
                  [idStr substringWithRange:NSMakeRange(2, 2)],
                  [idStr substringWithRange:NSMakeRange(4, 2)],
                  [idStr substringWithRange:NSMakeRange(6, 2)],
                  [idStr substringWithRange:NSMakeRange(8, 2)],
                  [idStr substringWithRange:NSMakeRange(10, 2)]];
    } else {
        NSLog(@"格式化mac地址, 原字符串格式不正确: %@", retVal);
    }
    
    return retVal;
}

#pragma mark mac地址串，不包含任何其他符号, ex: 000000000000
- (NSString *)peripheralMacAddress {
    NSString *retVal = self;
    
    if (self.length == (macAddressLength + 5)) {
        NSString *str = [self copy];
        
        retVal = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    } else {
        NSLog(@"mac地址串，不包含任何其他符号, 原mac地址不正确: %@", self);
    }
    
    return retVal;
}

#pragma mark 比较固件版本
- (BOOL)isEqualToFirmwareVersion:(NSString *)versionString {
    NSString *curV = self;
    NSComparisonResult result = [NSString compareFW1:curV FW2:versionString];
    
    if (result == NSOrderedSame || result == NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Method
+ (NSComparisonResult)compareFW1:(NSString *)fwV1 FW2:(NSString *)fwV2 {
    NSInteger v1 = [[self class] getCompareIntBFWVStr:fwV1];
    NSInteger v2 = [[self class] getCompareIntBFWVStr:fwV2];
    
    if (v1 == v2) {
        return NSOrderedSame;
    } else if (v1 > v2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending;
    }
}

// V1.15.3.1
// V1.15.3
+ (NSInteger)getCompareIntBFWVStr:(NSString *)fwVStr {
    NSInteger retV = 0;
    NSString *fw = fwVStr;
    
    if (![[fw uppercaseString] hasPrefix:@"V"]) {
        if ([fw rangeOfString:@"."].location != NSNotFound) {
            fw = [NSString stringWithFormat:@"V%@", fw];
        } else {
            NSInteger intV = [fw integerValue];
            
            if (intV > 0) {
                fw = [NSString stringWithFormat:@"V%@", fw];
            } else {
                return 0;
            }
        }
    }
    
    retV = [self getDecimalFromFWVerStr:fw];
    
    return retV;
}

+ (NSInteger)getDecimalFromFWVerStr:(NSString *)vStr {
    if ([vStr hasPrefix:@"V"] || [vStr hasPrefix:@"v"]) {
        NSString *numberStr = [vStr substringFromIndex:1];
        NSArray *components = [numberStr componentsSeparatedByString:@"."];
        NSInteger count = [components count];
        
        switch (count) {
            case 1:    // V1
            {
                return [components[0] integerValue];
            }
                break;
            case 3:   // V1.2.3
            {
                int32_t retV = 0;
                uint8_t num1 = atoi([components[0] UTF8String]);
                uint8_t num2 = atoi([components[1] UTF8String]);
                uint8_t num3 = atoi([components[2] UTF8String]);
                
                retV = (num1 << 16) | (num2 << 8) | num3;
                return retV;
            }
                break;
            case 4:   // V1.3.4.5
            {
                int32_t retV = 0;
                uint8_t num1 = atoi([components[0] UTF8String]);
                uint8_t num2 = atoi([components[1] UTF8String]);
                uint8_t num3 = atoi([components[2] UTF8String]);
                uint8_t num4 = atoi([components[3] UTF8String]);
                
                retV = (num1 << 24) | (num2 << 16) | (num3 << 8) | num4;
                return retV;
            }
                break;
            default:
                NSLog(@"Unsupport Fw file Version!!!!");
                return 0;
                break;
        }
    }
    
    NSLog(@"Unsupport Fw file Version!!!!, got V prefix??");
    return 0;
}


@end
