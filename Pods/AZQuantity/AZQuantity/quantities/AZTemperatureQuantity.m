//
//  AZTemperatureQuantity.m
//  AZQuantityDemo
//
//  Created by 朱立挺 on 2018/1/18.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//
#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>

@interface AZTemperatureQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZTemperatureQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeTemperature;
}

+ (instancetype)temperatureQuantityWithUnit:(AZQuantityUnit)unitType
                                      value:(AZQuantityValue)value {
    
    NSParameterAssert(unitType == AZQuantityTemperatureUnitDegreeCelsius ||
                      unitType == AZQuantityTemperatureUnitDegreeFahrenheit ||
                      unitType == AZQuantityTemperatureUnitKelvin);
    
    AZTemperatureQuantity *quantity = [self new];
    quantity.unit                   = unitType;
    
    HKUnit *unit;
    switch (unitType) {
        case AZQuantityTemperatureUnitDegreeCelsius:
            unit = [HKUnit degreeCelsiusUnit];
            break;
        case AZQuantityTemperatureUnitDegreeFahrenheit:
            unit = [HKUnit degreeFahrenheitUnit];
            break;
        case AZQuantityTemperatureUnitKelvin:
            unit = [HKUnit kelvinUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }
    
    quantity.quantityValue = [HKQuantity quantityWithUnit:unit doubleValue:value];
    
    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {
    
    NSParameterAssert(unitType == AZQuantityTemperatureUnitDegreeCelsius ||
                      unitType == AZQuantityTemperatureUnitDegreeFahrenheit ||
                      unitType == AZQuantityTemperatureUnitKelvin);
    
    if (unitType == self.unit) {
        return self;
    }
    
    HKUnit *unit;
    switch (unitType) {
        case AZQuantityTemperatureUnitDegreeCelsius:
            unit = [HKUnit degreeCelsiusUnit];
            break;
        case AZQuantityTemperatureUnitDegreeFahrenheit:
            unit = [HKUnit degreeFahrenheitUnit];
            break;
        case AZQuantityTemperatureUnitKelvin:
            unit = [HKUnit kelvinUnit];
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
        case AZQuantityTemperatureUnitDegreeCelsius:
            unit = [HKUnit degreeCelsiusUnit];
            break;
        case AZQuantityTemperatureUnitDegreeFahrenheit:
            unit = [HKUnit degreeFahrenheitUnit];
            break;
        case AZQuantityTemperatureUnitKelvin:
            unit = [HKUnit kelvinUnit];
            break;
        default:
            NSAssert(NO, @"Invalid unit");
            break;
    }
    
    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZTemperatureQuantity *)degreeCelsius {
    return [self toQuantityWithUnit:AZQuantityTemperatureUnitDegreeCelsius];
}

- (AZTemperatureQuantity *)degreeFahrenheit {
    return [self toQuantityWithUnit:AZQuantityTemperatureUnitDegreeFahrenheit];
}

- (AZTemperatureQuantity *)kelvin {
    return [self toQuantityWithUnit:AZQuantityTemperatureUnitKelvin];
}

@end
