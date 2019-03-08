//
//  HMLogConfiguration+Keys.m
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogConfiguration+Keys.h"

#import <objc/runtime.h>

#import "HMLogDefines.h"

// console group
HM_KEY(HMConfigurationGroupConsole)
HM_KEY(HMConfigurationKeyConsoleTimeZone)
HM_KEY(HMConfigurationKeyConsoleHideSeperator)
HM_KEY(HMConfigurationKeyConsoleFilterLevels)
HM_KEY(HMConfigurationKeyConsoleFilterTags)

// database group
HM_KEY(HMConfigurationGroupDatabase)
HM_KEY(HMConfigurationKeyDatabaseFlushInterval)
HM_KEY(HMConfigurationKeyDatabaseFlushItemCount)
HM_KEY(HMConfigurationKeyDatabaseMaximumItemCount)
HM_KEY(HMConfigurationKeyDatabaseFilterLevels)
HM_KEY(HMConfigurationKeyDatabaseFilterTags)


@interface HMLogConfiguration ()

@property (nonatomic, readwrite, strong) NSDictionary<NSString *, id> *configurationValues;

@end

@implementation HMLogConfiguration (Keys)

#pragma mark - setters and getters

- (void)setGroups:(NSDictionary<NSString *, id> *)configurationValues {
    objc_setAssociatedObject(self, "configurationValues", configurationValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary<NSString *, id> *)configurationValues {
    NSDictionary *groups = objc_getAssociatedObject(self, "configurationValues");
    if (!groups) {
        groups = [[self defaultConfigurationDictionary] mutableCopy];
        objc_setAssociatedObject(self, "configurationValues", groups, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return groups;
}

#pragma mark - private

- (NSDictionary<NSString *, id> *)defaultConfigurationDictionary {
    
    return @{
             // console
             HMConfigurationKeyConsoleTimeZone             : @8,
             HMConfigurationKeyConsoleHideSeperator        : @YES,
             HMConfigurationKeyConsoleFilterLevels         : @[],
             HMConfigurationKeyConsoleFilterTags           : @[],
             
             // database
             HMConfigurationKeyDatabaseFlushInterval       : @10,
             HMConfigurationKeyDatabaseFlushItemCount      : @10,
             HMConfigurationKeyDatabaseMaximumItemCount    : @1000,
             HMConfigurationKeyDatabaseFilterLevels        : @[@(HMLogLevelWarning), @(HMLogLevelError), @(HMLogLevelFatal)],
             HMConfigurationKeyDatabaseFilterTags          : @[]
             };
}

#pragma mark - public

- (id)configurationValueForKey:(NSString *)key {
    return self.configurationValues[key];
}

- (void)setConfigurationValue:(id)value
                       forKey:(NSString *)key {
    NSMutableDictionary *values = (NSMutableDictionary *)self.configurationValues;
    values[key] = value;
}

- (NSNumber *)numberForKey:(NSString *)key {
    id value = [self configurationValueForKey:key];
    
    if (!value) {
        return @0;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return @([value floatValue]);
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        if (array.count > 0) {
            return @([array.firstObject floatValue]);
        }
    }
    
    return @0;
}

- (NSString *)stringForKey:(NSString *)key {
    id value = [self configurationValueForKey:key];
    
    if (!value) {
        return @"";
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    return [NSString stringWithFormat:@"%@", value];
}

- (NSUInteger)integerForKey:(NSString *)key {
    NSNumber *value = [self configurationValueForKey:key];
    return value.integerValue;
}

- (double)doubleForKey:(NSString *)key {
    NSNumber *value = [self numberForKey:key];
    return value.doubleValue;
}

- (BOOL)boolForKey:(NSString *)key {
    
    id value = [self configurationValueForKey:key];
    
    if (!value) {
        return NO;
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value boolValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        
        NSString *valueString = value;
        
        if ([valueString.uppercaseString isEqualToString:@"TRUE"] ||
            [valueString.uppercaseString isEqualToString:@"YES"]) {
            return YES;
        }
        
        if ([valueString.uppercaseString isEqualToString:@"FALSE"] ||
            [valueString.uppercaseString isEqualToString:@"NO"]) {
            return NO;
        }
        
        return ([valueString integerValue] > 0);
    }
    
    return NO;
}

- (NSArray *)arrayForKey:(NSString *)key {
    
    id value = [self configurationValueForKey:key];
    
    if (!value) {
        return @[];
    }
    
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return @[value];
}

@end
