//
//  AZMassQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 16/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZMassQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZMassQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeMass;
}

+ (instancetype)massQuantityWithUnit:(AZQuantityUnit)unitType
                               value:(AZQuantityValue)value {
    NSParameterAssert(unitType == AZQuantityMassUnitGram ||
                      unitType == AZQuantityMassUnitKilogram ||
                      unitType == AZQuantityMassUnitPound ||
                      unitType == AZQuantityMassUnitJin);

    AZMassQuantity *quantity    = [self new];
    quantity.unit               = unitType;

    HKUnit *unit;
    switch (unitType) {
        case AZQuantityMassUnitGram:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitGram];
            break;
        case AZQuantityMassUnitKilogram:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            break;
        case AZQuantityMassUnitPound:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound];
            break;
        case AZQuantityMassUnitJin: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            value = value / 2;
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

    NSParameterAssert(unitType == AZQuantityMassUnitGram ||
                      unitType == AZQuantityMassUnitKilogram ||
                      unitType == AZQuantityMassUnitPound ||
                      unitType == AZQuantityMassUnitJin);

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit;
    AZQuantityValue value = 0.f;

    switch (unitType) {
        case AZQuantityMassUnitGram: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitGram];
            value = [self.quantityValue doubleValueForUnit:unit];
            break;
        }
        case AZQuantityMassUnitKilogram: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            value = [self.quantityValue doubleValueForUnit:unit];
            break;
        }
        case AZQuantityMassUnitPound: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound];
            value = [self.quantityValue doubleValueForUnit:unit];
            break;
        }
        case AZQuantityMassUnitJin: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            value = [self.quantityValue doubleValueForUnit:unit] * 2;
            break;
        }
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }

    return [[self class] quantityWithUnit:unitType value:value];
}

- (AZQuantityValue)value {

    HKUnit *unit;

    switch (self.unit) {
        case AZQuantityMassUnitGram:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitGram];
            break;
        case AZQuantityMassUnitKilogram:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            break;
        case AZQuantityMassUnitPound:
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitPound];
            break;
        case AZQuantityMassUnitJin: {
            unit = [HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram];
            return [self.quantityValue doubleValueForUnit:unit] * 2;
        }
        default:
            NSAssert(NO, @"Invalid unit type");
            return 0.f;
    }

    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZMassQuantity *)gram {
    return [self toQuantityWithUnit:AZQuantityMassUnitGram];
}

- (AZMassQuantity *)kilogram {
    return [self toQuantityWithUnit:AZQuantityMassUnitKilogram];
}

- (AZMassQuantity *)pound {
    return [self toQuantityWithUnit:AZQuantityMassUnitPound];
}

- (AZMassQuantity *)jin {
    return [self toQuantityWithUnit:AZQuantityMassUnitJin];
}

@end
