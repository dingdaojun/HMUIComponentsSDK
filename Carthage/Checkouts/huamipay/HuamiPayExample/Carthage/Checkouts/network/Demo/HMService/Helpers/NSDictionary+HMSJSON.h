//
//  NSDictionary+HMSJSON.h
//  HMNetworkLayer
//
//  Created by 李宪 on 14/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMServiceJSONValue;

@interface NSDictionary (HMServiceJSON)
@property (readonly) HMServiceJSONValue *hmjson;
@end


@interface HMServiceJSONValue : NSObject

@property (readonly) NSString *string;
@property (readonly) NSNumber *number;
@property (readonly) BOOL boolean;

@property (readonly) NSArray *array;
@property (readonly) NSDictionary *dictionary;

- (instancetype)objectForKeyedSubscript:(NSString *)key;
- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;

- (instancetype)objectForPossibleKeys:(NSArray<NSString *> *)keys;

@end


@interface HMServiceJSONValue (NumericalValue)
@property (readonly) NSUInteger unsignedIntegerValue;
@property (readonly) NSInteger integerValue;
@property (readonly) double doubleValue;
@property (readonly) float floatValue;
@end


@interface HMServiceJSONValue (NSDate)
@property (readonly) NSDate *date; // use value as NSTimeInterval
- (NSDate *)dateWithFormat:(NSString *)format;
@end


@interface HMServiceJSONValue (NSData)
@property (readonly) NSData *base64Data;
@end


@interface HMServiceJSONValue (UIColor)
@property (readonly) UIColor *color;
@end
