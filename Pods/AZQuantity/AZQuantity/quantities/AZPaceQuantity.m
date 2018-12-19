//
//  AZPaceQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 21/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZPaceQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZPaceQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypePace;
}

+ (HKUnit *)unitWithType:(AZQuantityUnit)unitType {
    NSParameterAssert(unitType == AZQuantityPaceUnitSecondsPerMeter ||
                      unitType == AZQuantityPaceUnitSecondsPer100Meter ||
                      unitType == AZQuantityPaceUnitSecondsPerKilometer ||
                      unitType == AZQuantityPaceUnitSecondsPerMile ||
                      unitType == AZQuantityPaceUnitSecondsPer100Yard ||
                      unitType == AZQuantityPaceUnitSecondsPerYard);

    HKUnit *secondUnit = [HKUnit secondUnit];

    switch (unitType) {
        case AZQuantityPaceUnitSecondsPerMeter:
        case AZQuantityPaceUnitSecondsPer100Meter: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            return [secondUnit unitDividedByUnit:meterUnit];
        }
        case AZQuantityPaceUnitSecondsPerKilometer: {
            HKUnit *kilometerUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            return [secondUnit unitDividedByUnit:kilometerUnit];
        }
        case AZQuantityPaceUnitSecondsPerMile: {
            HKUnit *mileUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            return [secondUnit unitDividedByUnit:mileUnit];
        }
        case AZQuantityPaceUnitSecondsPer100Yard:
        case AZQuantityPaceUnitSecondsPerYard: {
            HKUnit *yardUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
            return [secondUnit unitDividedByUnit:yardUnit];
        }
            
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }
}

+ (instancetype)paceQuantityWithUnit:(AZQuantityUnit)unitType
                               value:(AZQuantityValue)value {

    AZPaceQuantity *quantity    = [self new];
    quantity.unit               = unitType;

    HKUnit *unit            = [self unitWithType:unitType];
    quantity.quantityValue  = [HKQuantity quantityWithUnit:unit doubleValue:value];

    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit            = [AZPaceQuantity unitWithType:unitType];
    AZQuantityValue value   = [self.quantityValue doubleValueForUnit:unit];

    return [AZPaceQuantity quantityWithUnit:unitType value:value];
}

- (AZQuantityValue)value {

    HKUnit *secondUnit = [HKUnit secondUnit];
    HKUnit *unit;
    
    switch (self.unit) {
        case AZQuantityPaceUnitSecondsPerMeter: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            unit = [secondUnit unitDividedByUnit:meterUnit];
            break;
        }
        case AZQuantityPaceUnitSecondsPer100Meter: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            unit = [secondUnit unitDividedByUnit:meterUnit];
            return [self.quantityValue doubleValueForUnit:unit] * 100;
        }
        case AZQuantityPaceUnitSecondsPerKilometer: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            unit = [secondUnit unitDividedByUnit:meterUnit];
            break;
        }
        case AZQuantityPaceUnitSecondsPerMile: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            unit = [secondUnit unitDividedByUnit:meterUnit];
            break;
        }
        case AZQuantityPaceUnitSecondsPerYard: {
            HKUnit *meterUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            unit = [secondUnit unitDividedByUnit:meterUnit];
            break;
        }
        case AZQuantityPaceUnitSecondsPer100Yard: {
            HKUnit *yardUnit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
            unit = [secondUnit unitDividedByUnit:yardUnit];
            return [self.quantityValue doubleValueForUnit:unit] * 100;
        }
           
        default:
            NSAssert(NO, @"Invalid unit type");
            return 0.f;
    }
    
    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZPaceQuantity *)secondsPerMeter {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPerMeter];
}

- (AZPaceQuantity *)secondsPer100Meter {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPer100Meter];
}

- (AZPaceQuantity *)secondsPerKilometer {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPerKilometer];
}

- (AZPaceQuantity *)secondsPerMile {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPerMile];
}

- (AZPaceQuantity *)secondsPer100Yard {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPer100Yard];
}

- (AZPaceQuantity *)secondsPerYard {
    return [self toQuantityWithUnit:AZQuantityPaceUnitSecondsPerYard];
}

- (AZSpeedQuantity *)speed {
    AZQuantityValue value;
    AZQuantityUnit speedUnit;

    switch (self.unit) {
        case AZQuantityPaceUnitSecondsPerMeter: {
            
            if (self.value != 0.f) {
                value = 1 / self.value;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitMeterPerSecond;
            break;
        }
        case AZQuantityPaceUnitSecondsPer100Meter: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value / 10.f;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitKilometersPerHour;
            break;
        }
        case AZQuantityPaceUnitSecondsPerKilometer: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitKilometersPerHour;
            break;
        }
        case AZQuantityPaceUnitSecondsPerMile: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitMilesPerHour;
            break;
        }
        case AZQuantityPaceUnitSecondsPer100Yard: {
            
            if (self.value != 0.f) {
                value = 3600 / self.value * 100.f;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitYardPerHour;
            break;
        }
        case AZQuantityPaceUnitSecondsPerYard: {
            
            if (self.value != 0.f) {
                value = 1 / self.value;
            }
            else {
                value = 0.f;
            }
            
            speedUnit = AZQuantitySpeedUnitYardPerHour;
            break;
        }
            
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }

    return [AZSpeedQuantity speedQuantityWithUnit:speedUnit value:value];
}

@end


@implementation AZPaceQuantity (ExtendedValue)

- (NSString *)roundValueString {
    switch (self.unit) {
        case AZQuantityPaceUnitSecondsPerMeter:
        case AZQuantityPaceUnitSecondsPer100Meter:
        case AZQuantityPaceUnitSecondsPerKilometer:
        case AZQuantityPaceUnitSecondsPer100Yard:
        case AZQuantityPaceUnitSecondsPerMile:
        case AZQuantityPaceUnitSecondsPerYard: {
            NSUInteger minutes = (NSInteger)self.floorValue / 60;
            NSUInteger seconds = (NSInteger)self.floorValue % 60;
            
            if (minutes > 99) {
                return @"--";
            }
            
            return [NSString stringWithFormat:@"%02d’%02d”", (int)minutes, (int)seconds];
        }
        default:
            NSAssert(NO, @"Invalid unit type");
            return nil;
    }
}

@end
