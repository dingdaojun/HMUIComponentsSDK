//
//  AZSpeedQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 21/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZSpeedQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZSpeedQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeSpeed;
}

+ (HKUnit *)unitWithType:(AZQuantityUnit)unitType {
    NSParameterAssert(unitType == AZQuantitySpeedUnitKilometersPerHour ||
                      unitType == AZQuantitySpeedUnitMilesPerHour ||
                      unitType == AZQuantitySpeedUnitMeterPerSecond ||
                      unitType == AZQuantitySpeedUnitYardPerHour
                      );

    HKUnit *hourUnit = [HKUnit hourUnit];

    switch (unitType) {
        case AZQuantitySpeedUnitKilometersPerHour: {
            HKUnit *kilometerUnit   = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            return [kilometerUnit unitDividedByUnit:hourUnit];
        }
        case AZQuantitySpeedUnitMilesPerHour: {
            HKUnit *mileUnit        = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            return [mileUnit unitDividedByUnit:hourUnit];
        }
        case AZQuantitySpeedUnitMeterPerSecond: {
            HKUnit *meterUnit       = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            HKUnit *secondUnit      = [HKUnit secondUnit];
            return [meterUnit unitDividedByUnit:secondUnit];
        }
        case AZQuantitySpeedUnitYardPerHour: {
            HKUnit *yardUnit        = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
            return [yardUnit unitDividedByUnit:yardUnit];
        }
            
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }
}

+ (instancetype)speedQuantityWithUnit:(AZQuantityUnit)unitType
                                value:(AZQuantityValue)value {

    AZSpeedQuantity *quantity   = [self new];
    quantity.unit               = unitType;

    HKUnit *unit            = [self unitWithType:unitType];
    quantity.quantityValue  = [HKQuantity quantityWithUnit:unit doubleValue:value];

    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit            = [AZSpeedQuantity unitWithType:unitType];
    AZQuantityValue value   = [self.quantityValue doubleValueForUnit:unit];

    return [AZSpeedQuantity quantityWithUnit:unitType value:value];
}

- (AZQuantityValue)value {

    HKUnit *unit = [AZSpeedQuantity unitWithType:self.unit];
    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZSpeedQuantity *)kilometersPerHour {
    return [self toQuantityWithUnit:AZQuantitySpeedUnitKilometersPerHour];
}

- (AZSpeedQuantity *)milesPerHour {
    return [self toQuantityWithUnit:AZQuantitySpeedUnitMilesPerHour];
}

- (AZSpeedQuantity *)meterPerSecond {
    return [self toQuantityWithUnit:AZQuantitySpeedUnitMeterPerSecond];
}

- (AZSpeedQuantity *)yardPerHour {
    return [self toQuantityWithUnit:AZQuantitySpeedUnitYardPerHour];
}

- (AZPaceQuantity *)pace {
    AZQuantityValue value;
    
    AZQuantityUnit paceUnit;

    switch (self.unit) {
        case AZQuantitySpeedUnitKilometersPerHour: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value;
            }
            else {
                value = 0.f;
            }
            
            paceUnit = AZQuantityPaceUnitSecondsPerKilometer;
            break;
        }
        case AZQuantitySpeedUnitMilesPerHour:{
            
            if (self.value != 0.f) {
                value = 3600 / self.value;
            }
            else {
                value = 0.f;
            }
            
            paceUnit = AZQuantityPaceUnitSecondsPerMile;
            break;
        }
        case AZQuantitySpeedUnitMeterPerSecond:{
            
            if (self.value != 0.f) {
                value = 1 / self.value;
            }
            else {
                value = 0.f;
            }
            
            paceUnit = AZQuantityPaceUnitSecondsPerMeter;
            break;
        }
        case AZQuantitySpeedUnitYardPerHour: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value;
            }
            else {
                value = 0.f;
            }
            
            paceUnit = AZQuantityPaceUnitSecondsPerYard;
            break;
        }
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }

    return [AZPaceQuantity paceQuantityWithUnit:paceUnit value:value];
}

@end
