//
//  AZScalarQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 16/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZScalarQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZScalarQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeScalar;
}

+ (instancetype)scalarQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value {
    NSParameterAssert(unitType == AZQuantityScalarUnitCount ||
                      unitType == AZQuantityScalarUnitPercent);

    AZScalarQuantity *quantity  = [self new];
    quantity.unit               = unitType;

    HKUnit *unit;
    switch (unitType) {
        case AZQuantityScalarUnitCount:
            unit = [HKUnit countUnit];
            break;
        case AZQuantityScalarUnitPercent: {
            if (value > 1.f || value < -1.f) {
                value /= 100.f;
            }
            unit = [HKUnit percentUnit];
            break;
        }
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }

    quantity.quantityValue = [HKQuantity quantityWithUnit:unit doubleValue:value];

    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    NSParameterAssert(unitType == AZQuantityScalarUnitCount ||
                      unitType == AZQuantityScalarUnitPercent);

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit;

    switch (unitType) {
        case AZQuantityScalarUnitCount:
            unit = [HKUnit countUnit];
            break;
        case AZQuantityScalarUnitPercent:
            unit = [HKUnit percentUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }

    AZQuantityValue value = [self.quantityValue doubleValueForUnit:unit];
    return [[self class] quantityWithUnit:unitType value:value];
}

- (AZQuantityValue)value {

    HKUnit *unit;

    switch (self.unit) {
        case AZQuantityScalarUnitCount:
            unit = [HKUnit countUnit];
            break;
        case AZQuantityScalarUnitPercent:
            unit = [HKUnit percentUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            return 0.f;
    }

    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZScalarQuantity *)count {
    return [self toQuantityWithUnit:AZQuantityScalarUnitCount];
}

- (AZScalarQuantity *)percent {
    return [self toQuantityWithUnit:AZQuantityScalarUnitPercent];
}

@end


@implementation AZScalarQuantity (ExtendedValue)

- (NSString *)roundValueString {
    switch (self.unit) {
        case AZQuantityScalarUnitPercent:
            //return [NSString stringWithFormat:@"%.2f%%", self.round2Value * 100];
            return [NSString localizedStringWithFormat:@"%.2f%%", self.round2Value * 100];
        default:
            return super.roundValueString;
    }
}

@end
