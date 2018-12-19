//
//  AZQuantityConfigurator.m
//  AZQuantityDemo
//
//  Created by 李宪 on 26/12/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "AZQuantityConfigurator.h"

@implementation AZQuantityConfigurator

#pragma mark - Private

- (NSString *)localizedStringForKey:(NSString *)key {

    NSBundle *classBundle = [NSBundle bundleForClass:[AZQuantityConfigurator class]];
    NSString *path = [classBundle pathForResource:@"AZQuantityConfigurator" ofType:@"bundle"];

    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return NSLocalizedStringFromTableInBundle(key, @"unit", bundle, NULL);
}

#pragma mark - AZQuantityConfigurator

- (AZQuantityRoundValueMode)roundValueModeForUnit:(AZQuantityUnit)unit {
    switch (unit) {
            // 重量单位
        case AZQuantityMassUnitGram:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityMassUnitKilogram:
            return AZQuantityRoundValueModeRound1;
        case AZQuantityMassUnitPound:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityMassUnitJin:
            return AZQuantityRoundValueModeRound0;

            // 长度单位
        case AZQuantityLengthUnitMeter:
            return AZQuantityRoundValueModeFloor;
        case AZQuantityLengthUnitKilometer:
            return AZQuantityRoundValueModeFloor2;
        case AZQuantityLengthUnitCentimeter:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityLengthUnitInch:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityLengthUnitMile:
            return AZQuantityRoundValueModeFloor2;
        case AZQuantityLengthUnitFoot:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityLengthUnitYard:
            return AZQuantityRoundValueModeRound0;

            // 能量单位
        case AZQuantityEnergyUnitCalorie:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityEnergyUnitKilocalorie:
            return AZQuantityRoundValueModeRound0;

            // 标量单位
        case AZQuantityScalarUnitCount:
            return AZQuantityRoundValueModeFloor;
        case AZQuantityScalarUnitPercent:
            return AZQuantityRoundValueModeRound2;

            // 时间单位
        case AZQuantityTimeUnitSecond:
            return AZQuantityRoundValueModeRound0;
        case AZQuantityTimeUnitMinute:
            return AZQuantityRoundValueModeRound1;
        case AZQuantityTimeUnitHour:
            return AZQuantityRoundValueModeRound1;

            // 速度
        case AZQuantitySpeedUnitKilometersPerHour:
        case AZQuantitySpeedUnitMilesPerHour:
        case AZQuantitySpeedUnitMeterPerSecond:
        case AZQuantitySpeedUnitYardPerHour:
            return AZQuantityRoundValueModeRound2;

            // 配速
        case AZQuantityPaceUnitSecondsPerMeter:
        case AZQuantityPaceUnitSecondsPer100Meter:
        case AZQuantityPaceUnitSecondsPer100Yard:
        case AZQuantityPaceUnitSecondsPerKilometer:
        case AZQuantityPaceUnitSecondsPerMile:
        case AZQuantityPaceUnitSecondsPerYard:
            return AZQuantityRoundValueModeRound0;
            
            // 温度单位
        case AZQuantityTemperatureUnitDegreeCelsius:
        case AZQuantityTemperatureUnitDegreeFahrenheit:
        case AZQuantityTemperatureUnitKelvin:
            return AZQuantityRoundValueModeRound0;
    }
}

- (NSString *)localizedUnitStringForUnit:(AZQuantityUnit)unit {

    switch (unit) {
            // 重量单位
        case AZQuantityMassUnitGram:
            return [self localizedStringForKey:@"克"];
        case AZQuantityMassUnitKilogram:
            return [self localizedStringForKey:@"公斤"];
        case AZQuantityMassUnitPound:
            return [self localizedStringForKey:@"磅"];
        case AZQuantityMassUnitJin:
            return [self localizedStringForKey:@"斤"];

            // 长度单位
        case AZQuantityLengthUnitMeter:
            return [self localizedStringForKey:@"米"];
        case AZQuantityLengthUnitKilometer:
            return [self localizedStringForKey:@"公里"];
        case AZQuantityLengthUnitCentimeter:
            return [self localizedStringForKey:@"厘米"];
        case AZQuantityLengthUnitInch:
            return [self localizedStringForKey:@"英寸"];
        case AZQuantityLengthUnitMile:
            return [self localizedStringForKey:@"英里"];
        case AZQuantityLengthUnitFoot:
            return [self localizedStringForKey:@"英尺"];
        case AZQuantityLengthUnitYard:
            return [self localizedStringForKey:@"码"];

            // 能量单位
        case AZQuantityEnergyUnitCalorie:
            return [self localizedStringForKey:@"卡"];
        case AZQuantityEnergyUnitKilocalorie:
            return [self localizedStringForKey:@"千卡"];

            // 标量单位
        case AZQuantityScalarUnitCount:
            return [self localizedStringForKey:@"次"];
        case AZQuantityScalarUnitPercent:
            return @"";

            // 时间单位
        case AZQuantityTimeUnitSecond:
            return [self localizedStringForKey:@"秒"];
        case AZQuantityTimeUnitMinute:
            return [self localizedStringForKey:@"分"];
        case AZQuantityTimeUnitHour:
            return [self localizedStringForKey:@"时"];

            // 速度
        case AZQuantitySpeedUnitKilometersPerHour:
            return [self localizedStringForKey:@"公里/小时"];
        case AZQuantitySpeedUnitMilesPerHour:
            return [self localizedStringForKey:@"英里/小时"];
        case AZQuantitySpeedUnitMeterPerSecond:
            return [self localizedStringForKey:@"米/秒"];
        case AZQuantitySpeedUnitYardPerHour:
            return [self localizedStringForKey:@"码/小时"];

            // 配速
        case AZQuantityPaceUnitSecondsPerMeter:
            return [self localizedStringForKey:@"分/米"];
        case AZQuantityPaceUnitSecondsPer100Meter:
            return [self localizedStringForKey:@"分/百米"];
        case AZQuantityPaceUnitSecondsPerKilometer:
            return [self localizedStringForKey:@"分/公里"];
        case AZQuantityPaceUnitSecondsPerMile:
            return [self localizedStringForKey:@"分/英里"];
        case AZQuantityPaceUnitSecondsPer100Yard:
            return [self localizedStringForKey:@"分/百码"];
        case AZQuantityPaceUnitSecondsPerYard:
            return [self localizedStringForKey:@"分/码"];
           // 温度
        case AZQuantityTemperatureUnitDegreeCelsius:
            return @"℃";
        case AZQuantityTemperatureUnitDegreeFahrenheit:
            return @"℉";
        case AZQuantityTemperatureUnitKelvin:
            return @"K";
    }
}

@end
