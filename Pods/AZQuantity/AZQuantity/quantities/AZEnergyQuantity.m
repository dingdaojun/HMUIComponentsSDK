//
//  AZEnergyQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 16/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZEnergyQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZEnergyQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeEnergy;
}

+ (instancetype)energyQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value {
    NSParameterAssert(unitType == AZQuantityEnergyUnitCalorie ||
                      unitType == AZQuantityEnergyUnitKilocalorie);

    AZEnergyQuantity *quantity  = [self new];
    quantity.unit               = unitType;

    HKUnit *unit;
    switch (unitType) {
        case AZQuantityEnergyUnitCalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitCalorie];
            break;
        case AZQuantityEnergyUnitKilocalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitKilocalorie];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }

    quantity.quantityValue = [HKQuantity quantityWithUnit:unit doubleValue:value];
    
    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    NSParameterAssert(unitType == AZQuantityEnergyUnitCalorie ||
                      unitType == AZQuantityEnergyUnitKilocalorie);

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit;

    switch (unitType) {
        case AZQuantityEnergyUnitCalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitCalorie];
            break;
        case AZQuantityEnergyUnitKilocalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitKilocalorie];
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
        case AZQuantityEnergyUnitCalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitCalorie];
            break;
        case AZQuantityEnergyUnitKilocalorie:
            unit = [HKUnit unitFromEnergyFormatterUnit:NSEnergyFormatterUnitKilocalorie];
            break;
        default:
            NSAssert(NO, @"Invalid type");
            break;
    }

    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZEnergyQuantity *)calorie {
    return [self toQuantityWithUnit:AZQuantityEnergyUnitCalorie];
}

- (AZEnergyQuantity *)kilocalorie {
    return [self toQuantityWithUnit:AZQuantityEnergyUnitKilocalorie];
}

@end
