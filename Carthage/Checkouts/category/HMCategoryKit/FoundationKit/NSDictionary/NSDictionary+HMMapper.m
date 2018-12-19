//
//  NSDictionary+HMMapper.m
//  HMCategorySourceCodeExample
//
//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)
//

#import "NSDictionary+HMMapper.h"
#import "NSDateFormatter+HMGenerate.h"

@implementation NSObject (HMMapperJSON)

// Just to avoid crash when a NSDictionary * pointer actually pointed to another kind class, eg., NSArray.
- (HMMapperJSONValue *)hmjson {
    return nil;
}

@end


@interface HMMapperJSONValue ()
@property (nonatomic, strong) id object;
@end


@implementation NSDictionary (HMMapperJSON)

- (HMMapperJSONValue *)hmmap {
    HMMapperJSONValue *JSON = [HMMapperJSONValue new];
    JSON.object = self;
    return JSON;
}

@end


@implementation HMMapperJSONValue

- (NSString *)string {
    
    if ([self.object isKindOfClass:[NSString class]]) {
        return (NSString *)self.object;
    }
    
    if ([self.object isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", self.object];
    }
    
    return nil;
}

- (NSNumber *)number {
    
    if ([self.object isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self.object;
    }
    
    if ([self.object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)self.object;
        
        if ([string.lowercaseString isEqualToString:@"true"]) {
            return @YES;
        }
        
        if ([string.lowercaseString isEqualToString:@"false"]) {
            return @NO;
        }
        
        return [NSNumber numberWithDouble:string.doubleValue];
    }
    
    return nil;
}

- (BOOL)boolean {
    return self.number.boolValue;
}

- (NSArray *)array {
    
    if ([self.object isKindOfClass:[NSArray class]]) {
        return (NSArray *)self.object;
    }
    
    if ([self.object isKindOfClass:[NSString class]]) {
        NSString *jsonString = (NSString *)self.object;
        NSData *jsonData = [[NSData alloc] initWithBase64EncodedString:jsonString options:0];
        if (jsonData.length == 0) {
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            if (jsonData.length == 0) {
                return nil;
            }
        }
        
        NSError *error = nil;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error && [array isKindOfClass:[NSArray class]]) {
            return array;
        }
    }
    
    return nil;
}

- (NSDictionary *)dictionary {
    
    if ([self.object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)self.object;
    }
    
    if ([self.object isKindOfClass:[NSString class]]) {
        NSString *jsonString = (NSString *)self.object;
        NSData *jsonData = [[NSData alloc] initWithBase64EncodedString:jsonString options:0];
        if (jsonData.length == 0) {
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            if (jsonData.length == 0) {
                return nil;
            }
        }
        
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error && [dictionary isKindOfClass:[NSDictionary class]]) {
            return dictionary;
        }
    }
    
    return nil;
}

- (HMMapperJSONValue *)objectForKeyedSubscript:(NSString *)key {
    
    NSDictionary *dictionary = self.dictionary;
    if (!dictionary) {
        return nil;
    }
    
    HMMapperJSONValue *value = [HMMapperJSONValue new];
    value.object = dictionary[key];
    return value;
}

- (HMMapperJSONValue *)objectAtIndexedSubscript:(NSUInteger)idx {
    
    NSArray *array = self.array;
    if (!array) {
        return nil;
    }
    if (idx >= array.count) {
        return nil;
    }
    
    HMMapperJSONValue *value = [HMMapperJSONValue new];
    value.object = array[idx];
    return value;
}

- (instancetype)objectForPossibleKeys:(NSArray<NSString *> *)keys {
    
    NSDictionary *dictionary = self.dictionary;
    if (!dictionary) {
        return nil;
    }
    
    for (NSString *key in keys) {
        id obj = dictionary[key];
        if (obj) {
            HMMapperJSONValue *value = [HMMapperJSONValue new];
            value.object = obj;
            return value;
        }
    }

    return nil;
}

@end


@implementation HMMapperJSONValue (NumericalValue)

- (NSUInteger)unsignedIntegerValue {
    return self.number.unsignedIntegerValue;
}

- (NSInteger)integerValue {
    return self.number.integerValue;
}

- (double)doubleValue {
    return self.number.doubleValue;
}

- (float)floatValue {
    return self.number.floatValue;
}

@end

@implementation HMMapperJSONValue (NSDate)

- (NSDate *)date {
    NSTimeInterval timeInterval = self.number.doubleValue;
    if (timeInterval == 0.f) {
        return nil;
    }
    
    if (timeInterval > (1e12)) {
        timeInterval /= 1000.f;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

- (NSDate *)dateWithFormat:(NSString *)format {
    NSString *string = self.string;
    if (string.length == 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter formatter];
    formatter.dateFormat = format;
    
    return [formatter dateFromString:string];
}

@end


@implementation HMMapperJSONValue (NSData)

- (NSData *)base64Data {
    
    NSString *base64String = self.string;
    if (base64String.length == 0) {
        return nil;
    }
    
    return [[NSData alloc] initWithBase64EncodedString:base64String options:0];
}

@end


@implementation HMMapperJSONValue (UIColor)

- (UIColor *)color {
    if ([self.object isKindOfClass:[UIColor class]]) {
        return self.object;
    }
    
    if ([self.object isKindOfClass:[NSString class]]) {
        NSString *colorString = [self.string stringByReplacingOccurrencesOfString:@"#" withString:@""];
        
        if (colorString.length != 6) {
            return nil;
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:colorString];
        unsigned int hex;
        if (![scanner scanHexInt:&hex]) {
            return nil;
        }
        
        NSUInteger r = (hex & 0xFF0000) >> 16;
        NSUInteger g = (hex & 0xFF00) >> 8;
        NSUInteger b = (hex & 0xFF);
        
        return [UIColor colorWithRed:r / 255.f
                               green:g / 255.f
                                blue:b / 255.f
                               alpha:1.f];
    }
    
    return nil;
}

@end
