//
//  NSDictionary+HMMapper.h
//  HMCategorySourceCodeExample
//
//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)
//

#import <UIKit/UIKit.h>

@class HMMapperJSONValue;

@interface NSDictionary (HMMapperJSON)
@property (nonatomic, strong, readonly) HMMapperJSONValue *hmmap;
@end


@interface HMMapperJSONValue : NSObject

@property (nonatomic, copy, readonly) NSString *string;
@property (nonatomic, strong, readonly) NSNumber *number;
@property (nonatomic, assign, readonly) BOOL boolean;

@property (nonatomic, strong, readonly) NSArray *array;
@property (nonatomic, strong, readonly) NSDictionary *dictionary;

- (instancetype)objectForKeyedSubscript:(NSString *)key;
- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;

- (instancetype)objectForPossibleKeys:(NSArray<NSString *> *)keys;

@end


@interface HMMapperJSONValue (NumericalValue)
@property (nonatomic, assign, readonly) NSUInteger unsignedIntegerValue;
@property (nonatomic, assign, readonly) NSInteger integerValue;
@property (nonatomic, assign, readonly) double doubleValue;
@property (nonatomic, assign, readonly) float floatValue;
@end


@interface HMMapperJSONValue (NSDate)
@property (nonatomic, strong, readonly) NSDate *date; // use value as NSTimeInterval
- (NSDate *)dateWithFormat:(NSString *)format;
@end


@interface HMMapperJSONValue (NSData)
@property (nonatomic, strong, readonly) NSData *base64Data;
@end


@interface HMMapperJSONValue (UIColor)
@property (nonatomic, strong, readonly) UIColor *color;
@end
