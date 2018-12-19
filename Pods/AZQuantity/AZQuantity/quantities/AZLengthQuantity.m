//
//  AZLengthQuantity.m
//  AmazfitWatch
//
//  Created by 李宪 on 16/10/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantity.h"
#import <HealthKit/HealthKit.h>


@interface AZLengthQuantity ()
@property (nonatomic, strong, readwrite) HKQuantity *quantityValue;
@property (nonatomic, assign, readwrite) AZQuantityUnit unit;
@end

@implementation AZLengthQuantity

@dynamic quantityValue, unit;

#pragma mark - Subclassing

- (AZQuantityType)type {
    return AZQuantityTypeLength;
}

+ (instancetype)lengthQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value {
    NSParameterAssert(unitType == AZQuantityLengthUnitMeter ||
                      unitType == AZQuantityLengthUnitKilometer ||
                      unitType == AZQuantityLengthUnitCentimeter ||
                      unitType == AZQuantityLengthUnitInch ||
                      unitType == AZQuantityLengthUnitMile ||
                      unitType == AZQuantityLengthUnitFoot ||
                      unitType == AZQuantityLengthUnitYard);
    
    AZLengthQuantity *quantity  = [self new];
    quantity.unit               = unitType;

    HKUnit *unit;
    switch (unitType) {
        case AZQuantityLengthUnitMeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            break;
        case AZQuantityLengthUnitKilometer:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            break;
        case AZQuantityLengthUnitCentimeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitCentimeter];
            break;
        case AZQuantityLengthUnitInch:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitInch];
            break;
        case AZQuantityLengthUnitMile:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            break;
        case AZQuantityLengthUnitFoot:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitFoot];
            break;
        case AZQuantityLengthUnitYard:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
            break;
        default:
            NSAssert(NO, @"Invalid unit type");
            break;
    }

    quantity.quantityValue = [HKQuantity quantityWithUnit:unit doubleValue:value];
    
    return quantity;
}

- (instancetype)toQuantityWithUnit:(AZQuantityUnit)unitType {

    NSParameterAssert(unitType == AZQuantityLengthUnitMeter ||
                      unitType == AZQuantityLengthUnitKilometer ||
                      unitType == AZQuantityLengthUnitCentimeter ||
                      unitType == AZQuantityLengthUnitInch ||
                      unitType == AZQuantityLengthUnitMile ||
                      unitType == AZQuantityLengthUnitFoot ||
                      unitType == AZQuantityLengthUnitYard
                      );

    if (unitType == self.unit) {
        return self;
    }

    HKUnit *unit;

    switch (unitType) {
        case AZQuantityLengthUnitMeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            break;
        case AZQuantityLengthUnitKilometer:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            break;
        case AZQuantityLengthUnitCentimeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitCentimeter];
            break;
        case AZQuantityLengthUnitInch:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitInch];
            break;
        case AZQuantityLengthUnitMile:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            break;
        case AZQuantityLengthUnitFoot:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitFoot];
            break;
        case AZQuantityLengthUnitYard:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
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
        case AZQuantityLengthUnitMeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMeter];
            break;
        case AZQuantityLengthUnitKilometer:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitKilometer];
            break;
        case AZQuantityLengthUnitCentimeter:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitCentimeter];
            break;
        case AZQuantityLengthUnitInch:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitInch];
            break;
        case AZQuantityLengthUnitMile:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitMile];
            break;
        case AZQuantityLengthUnitFoot:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitFoot];
            break;
        case AZQuantityLengthUnitYard:
            unit = [HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitYard];
            break;
        default:
            NSAssert(NO, @"Invalid unit");
            break;
    }

    return [self.quantityValue doubleValueForUnit:unit];
}

#pragma mark - Convert

- (AZLengthQuantity *)meter {
    return [self toQuantityWithUnit:AZQuantityLengthUnitMeter];
}

- (AZLengthQuantity *)kilometer {
    return [self toQuantityWithUnit:AZQuantityLengthUnitKilometer];
}

- (AZLengthQuantity *)centimeter {
    return [self toQuantityWithUnit:AZQuantityLengthUnitCentimeter];
}

- (AZLengthQuantity *)inch {
    return [self toQuantityWithUnit:AZQuantityLengthUnitInch];
}

- (AZLengthQuantity *)mile {
    return [self toQuantityWithUnit:AZQuantityLengthUnitMile];
}

- (AZLengthQuantity *)foot {
    return [self toQuantityWithUnit:AZQuantityLengthUnitFoot];
}

- (AZLengthQuantity *)yard {
    return [self toQuantityWithUnit:AZQuantityLengthUnitYard];
}

@end
