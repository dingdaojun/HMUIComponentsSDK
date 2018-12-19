//
//  AZTimeQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 16/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZTimeQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZTimeQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeTime;
}

+ (instancetype)timeQuantityWithUnit:(AZQuantityUnit)unitType
                               value:(AZQuantityValue)value {
    NSParameterAssert(unitType == AZQuantityTimeUnitSecond ||
                      unitType == AZQuantityTimeUnitMinute ||
                      unitType == AZQuantityTimeUnitHour);

    AZTimeQuantity *quantity    = [self new];
    quantity.unit               = unitType;

    HKUnit *unit;
    switch (unitType) {
        case AZQuantityTimeUnitSecond:
            unit = [HKUnit secondUnit];
            break;
        case AZQuantityTimeUnitMinute:
            unit = [HKUnit minuteUnit];
            break;
        case AZQuantityTimeUnitHour:
            unit = [HKUnit hourUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }

    quantity.quantityValue = [HKQuantity quantityWithUnit:unit doubleValue:value];

    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    NSParameterAssert(unitType == AZQuantityTimeUnitSecond ||
                      unitType == AZQuantityTimeUnitMinute ||
                      unitType == AZQuantityTimeUnitHour);

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit;

    switch (unitType) {
        case AZQuantityTimeUnitSecond:
            unit = [HKUnit secondUnit];
            break;
        case AZQuantityTimeUnitMinute:
            unit = [HKUnit minuteUnit];
            break;
        case AZQuantityTimeUnitHour:
            unit = [HKUnit hourUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }

    AZQuantityValue value = [self.quantityValue doubleValueForUnit:unit];
    return [[self class] quantityWithUnit:unitType value:value];
}

- (AZQuantityValue)value {

    HKUnit *unit;

    switch (self.unit) {
        case AZQuantityTimeUnitSecond:
            unit = [HKUnit secondUnit];
            break;
        case AZQuantityTimeUnitMinute:
            unit = [HKUnit minuteUnit];
            break;
        case AZQuantityTimeUnitHour:
            unit = [HKUnit hourUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            return 0.f;
    }

    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZTimeQuantity *)second {
    return [self toQuantityWithUnit:AZQuantityTimeUnitSecond];
}

- (AZTimeQuantity *)minute {
    return [self toQuantityWithUnit:AZQuantityTimeUnitMinute];
}

- (AZTimeQuantity *)hour {
    return [self toQuantityWithUnit:AZQuantityTimeUnitHour];
}

@end
