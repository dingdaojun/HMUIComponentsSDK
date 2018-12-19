//
//  AZQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 30/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <objc/runtime.h>
#import <HealthKit/HealthKit.h>

#import "AZQuantityConfigurator.h"

@interface AZQuantity ()
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@end

@implementation AZQuantity

- (instancetype)init {
    if ([NSStringFromClass([self class]) isEqualToString:@"AZQuantity"]) {
        [self doesNotRecognizeSelector:_cmd];
    }
    
    return [super init];
}

+ (instancetype)quantityWithUnit:(AZQuantityUnit)unit
                           value:(AZQuantityValue)value {

    switch (unit) {
        case AZQuantityMassUnitKilogram:
        case AZQuantityMassUnitGram:
        case AZQuantityMassUnitJin:
        case AZQuantityMassUnitPound:
            return [AZMassQuantity massQuantityWithUnit:unit value:value];
            
        case AZQuantityLengthUnitMeter:
        case AZQuantityLengthUnitKilometer:
        case AZQuantityLengthUnitCentimeter:
        case AZQuantityLengthUnitInch:
        case AZQuantityLengthUnitMile:
        case AZQuantityLengthUnitFoot:
        case AZQuantityLengthUnitYard:
            return [AZLengthQuantity lengthQuantityWithUnit:unit value:value];
            
        case AZQuantityEnergyUnitCalorie:
        case AZQuantityEnergyUnitKilocalorie:
            return [AZEnergyQuantity energyQuantityWithUnit:unit value:value];

        case AZQuantityScalarUnitCount:
        case AZQuantityScalarUnitPercent:
            return [AZScalarQuantity scalarQuantityWithUnit:unit value:value];

        case AZQuantityTimeUnitSecond:
        case AZQuantityTimeUnitMinute:
        case AZQuantityTimeUnitHour:
            return [AZTimeQuantity timeQuantityWithUnit:unit value:value];

        case AZQuantitySpeedUnitKilometersPerHour:
        case AZQuantitySpeedUnitMilesPerHour:
        case AZQuantitySpeedUnitMeterPerSecond:
        case AZQuantitySpeedUnitYardPerHour:
            return [AZSpeedQuantity speedQuantityWithUnit:unit value:value];

        case AZQuantityPaceUnitSecondsPerMeter:
        case AZQuantityPaceUnitSecondsPerKilometer:
        case AZQuantityPaceUnitSecondsPerMile:
        case AZQuantityPaceUnitSecondsPer100Meter:
        case AZQuantityPaceUnitSecondsPer100Yard:
        case AZQuantityPaceUnitSecondsPerYard:
            return [AZPaceQuantity paceQuantityWithUnit:unit value:value];

        case AZQuantityTemperatureUnitDegreeCelsius:
        case AZQuantityTemperatureUnitDegreeFahrenheit:
        case AZQuantityTemperatureUnitKelvin:
            return [AZTemperatureQuantity temperatureQuantityWithUnit:unit value:value];

    }
}

- (AZQuantityValue)value {
    [self doesNotRecognizeSelector:_cmd];
    return 0.f;
}

#pragma mark - 配置

+ (void)setConfigurator:(id<AZQuantityConfigurator>)configurator {
    objc_setAssociatedObject(self, "configurator", configurator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (id<AZQuantityConfigurator>)configurator {
    id<AZQuantityConfigurator>configurator = objc_getAssociatedObject(self, "configurator");
    if (!configurator) {
        configurator = [AZQuantityConfigurator new];
        objc_setAssociatedObject(self, "configurator", configurator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return configurator;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.unit = [aDecoder decodeIntegerForKey:@"unit"];
        self.quantityValue = [aDecoder decodeObjectForKey:@"quantityValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.unit forKey:@"unit"];
    [aCoder encodeObject:self.quantityValue forKey:@"quantityValue"];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Description

- (NSString *)description {
    NSString *description = [super.description stringByAppendingString:@", "];
    description = [description stringByAppendingFormat:@"unit - %@, ", self.localizedUnitString];
    //description = [description stringByAppendingFormat:@"value - %.2f", self.value];
    description = [NSString localizedStringWithFormat:@"%@value - %.2f",description,self.value];
    return description;
}

- (NSString *)debugDescription {
    return self.description;
}

@end


@implementation AZQuantity (ExtendedValue)

+ (NSString *)localizedUnitStringForUnit:(AZQuantityUnit)unit {
    id<AZQuantityConfigurator>configurator = self.configurator;
    return [configurator localizedUnitStringForUnit:unit];
}

#pragma mark - unit string

- (NSString *)localizedUnitString {
    id<AZQuantityConfigurator>configurator = [self class].configurator;
    return [configurator localizedUnitStringForUnit:self.unit];
}

#pragma mark - round value

- (AZQuantityValue)round0Value {
    AZQuantityValue value = self.value;
    if (value >= 0.f) {
        return (NSUInteger)(value + .5f);
    }
    else {
        return (NSInteger)(value - .5f);
    }
}

- (AZQuantityValue)round1Value {
    AZQuantityValue value = self.value;
    if (value >= 0.f) {
        return (NSUInteger)((value + .05) * 10) / 10.f;
    }
    else {
        return (NSInteger)((value - .05) * 10) / 10.f;
    }
}

- (AZQuantityValue)round2Value {
    AZQuantityValue value = self.value;
    if (value >= 0.f) {
        return (NSUInteger)((value + .005) * 100) / 100.f;
    }
    else {
        return (NSInteger)((value - .005) * 100) / 100.f;
    }
}

- (AZQuantityValue)floorValue {
    return floor(self.value);
}

- (AZQuantityValue)floor1Value{
    AZQuantityValue value = self.value;
    if (value >= 0.f) {
        value += 0.000000001;
    }
    else {
        value -= 0.000000001;
    }
    return floor(value * 10) / 10;
}

- (AZQuantityValue)floor2Value{
    AZQuantityValue value = self.value;
    if (value >= 0.f) {
        value += 0.000000001;
    }
    else {
        value -= 0.000000001;
    }
   return floor(value * 100) / 100;
}

- (AZQuantityValue)roundValue {
    id<AZQuantityConfigurator>configurator = [self class].configurator;
    AZQuantityRoundValueMode mode = [configurator roundValueModeForUnit:self.unit];

    switch (mode) {
        case AZQuantityRoundValueModeRound0:
            return self.round0Value;
        case AZQuantityRoundValueModeRound1:
            return self.round1Value;
        case AZQuantityRoundValueModeRound2:
            return self.round2Value;
        case AZQuantityRoundValueModeFloor:
            return self.floorValue;
        case AZQuantityRoundValueModeFloor1:
            return self.floor1Value;
        case AZQuantityRoundValueModeFloor2:
            return self.floor2Value;
    }
}

- (NSString *)stringFromValue:(AZQuantityValue)value format:(NSString *)format {
    NSParameterAssert(format.length > 0);
    //return [NSString stringWithFormat:format, value];
    return [NSString localizedStringWithFormat:format,value];
}

- (NSString *)valueStringWithFormat:(NSString *)format {
    return [self stringFromValue:self.value format:format];
}

- (NSString *)round0ValueString {
    return [self stringFromValue:self.round0Value format:@"%.0f"];
}

- (NSString *)round1ValueString {
    return [self stringFromValue:self.round1Value format:@"%.1f"];
}

- (NSString *)round2ValueString {
    return [self stringFromValue:self.round2Value format:@"%.2f"];
}

- (NSString *)floorValueString {
    return [self stringFromValue:self.floorValue format:@"%.0f"];
}

- (NSString *)floor1ValueString {
    return [self stringFromValue:self.floor1Value format:@"%.1f"];
}

- (NSString *)floor2ValueString {
    return [self stringFromValue:self.floor2Value format:@"%.2f"];
}

- (NSString *)roundValueString {

    id<AZQuantityConfigurator>configurator = [self class].configurator;
    AZQuantityRoundValueMode mode = [configurator roundValueModeForUnit:self.unit];

    switch (mode) {
        case AZQuantityRoundValueModeRound0:
            return self.round0ValueString;
        case AZQuantityRoundValueModeRound1:
            return self.round1ValueString;
        case AZQuantityRoundValueModeRound2:
            return self.round2ValueString;
        case AZQuantityRoundValueModeFloor:
            return self.floorValueString;
        case AZQuantityRoundValueModeFloor1:
            return self.floor1ValueString;
        case AZQuantityRoundValueModeFloor2:
            return self.floor2ValueString;
    }
}

@end
