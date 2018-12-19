//
//  AZQuantity.h
//  AmazfitWatch
//
//  Created by 李宪 on 30/9/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZPaceQuantity;


typedef NS_ENUM(NSUInteger, AZQuantityType) {
    AZQuantityTypeMass,                 // 重量
    AZQuantityTypeLength,               // 长度
    AZQuantityTypeEnergy,               // 能量
    AZQuantityTypeScalar,               // 标量
    AZQuantityTypeTime,                 // 时间
    AZQuantityTypeSpeed,                // 速度
    AZQuantityTypePace,                 // 配速
    AZQuantityTypeTemperature           // 温度
};


typedef NS_ENUM(NSUInteger, AZQuantityUnit) {
    AZQuantityMassUnitGram                      = 0,            // 克
    AZQuantityMassUnitKilogram                  = 1,            // 千克
    AZQuantityMassUnitPound                     = 2,            // 磅
    AZQuantityMassUnitJin                       = 3,            // 斤

    AZQuantityLengthUnitMeter                   = 4,            // 米
    AZQuantityLengthUnitKilometer               = 5,            // 千米
    AZQuantityLengthUnitCentimeter              = 6,            // 厘米
    AZQuantityLengthUnitInch                    = 7,            // 英寸
    AZQuantityLengthUnitMile                    = 8,            // 英里
    AZQuantityLengthUnitFoot                    = 9,            // 英尺
    AZQuantityLengthUnitYard                    = 27,           // 码

    AZQuantityEnergyUnitCalorie                 = 10,           // 卡路里
    AZQuantityEnergyUnitKilocalorie             = 11,           // 千卡

    AZQuantityScalarUnitCount                   = 12,           // 标量，个
    AZQuantityScalarUnitPercent                 = 13,           // 标量，百分之

    AZQuantityTimeUnitSecond                    = 14,           // 秒
    AZQuantityTimeUnitMinute                    = 15,           // 分
    AZQuantityTimeUnitHour                      = 16,           // 时

    AZQuantitySpeedUnitKilometersPerHour        = 17,           // 公里/小时
    AZQuantitySpeedUnitMilesPerHour             = 18,           // 英里/小时
    AZQuantitySpeedUnitMeterPerSecond           = 19,           // 米/秒
    AZQuantitySpeedUnitYardPerHour              = 29,           // 码/小时
    

    AZQuantityPaceUnitSecondsPerMeter           = 20,           // 秒/米
    AZQuantityPaceUnitSecondsPerYard            = 30,           // 秒/码
    AZQuantityPaceUnitSecondsPer100Meter        = 21,           // 秒/百米
    AZQuantityPaceUnitSecondsPer100Yard         = 28,           // 秒/百码
    AZQuantityPaceUnitSecondsPerKilometer       = 22,           // 秒/公里
    AZQuantityPaceUnitSecondsPerMile            = 23,           // 秒/英里
    
    AZQuantityTemperatureUnitDegreeCelsius      = 24,           // 摄氏度
    AZQuantityTemperatureUnitDegreeFahrenheit   = 25,           // 华氏度
    AZQuantityTemperatureUnitKelvin             = 26,           // 开氏度 (卡尔文)
};


typedef NS_ENUM(NSUInteger, AZQuantityRoundValueMode) {
    AZQuantityRoundValueModeRound0,         // 四舍五入到整数位
    AZQuantityRoundValueModeRound1,         // 四舍五入到小数点第1位
    AZQuantityRoundValueModeRound2,         // 四舍五入到小数点第2位
    AZQuantityRoundValueModeFloor,          // 向下取整到整数位
    AZQuantityRoundValueModeFloor1,         // 忽略小数点第1位后
    AZQuantityRoundValueModeFloor2          // 忽略小数点第2位后
};


typedef double AZQuantityValue;



/**
 AZQuantity的单位本地化字符串、取值精度等的配置实现者协议
 */
@protocol AZQuantityConfigurator <NSObject>

- (AZQuantityRoundValueMode)roundValueModeForUnit:(AZQuantityUnit)unit;
- (NSString *)localizedUnitStringForUnit:(AZQuantityUnit)unit;

@end


/**
 AZQuantity类用来代表运动功能的所有单位量，包括距离、重量、能量等，因此可作为最基础的原子属性被MVC的各个模块引用。
 参考自Health Kit的HKQuantity。
 */
@interface AZQuantity : NSObject <NSCoding, NSCopying>

@property (readonly) AZQuantityType type;
@property (readonly) AZQuantityUnit unit;
@property (readonly) AZQuantityValue value;

+ (instancetype)quantityWithUnit:(AZQuantityUnit)unit
                           value:(AZQuantityValue)value;

#pragma mark - 配置

@property (class, nonatomic, strong) id<AZQuantityConfigurator> configurator;

@end


@interface AZQuantity (ExtendedValue)

/**
 单位字符串
 */
+ (NSString *)localizedUnitStringForUnit:(AZQuantityUnit)unit;

@property (readonly) NSString *localizedUnitString;

/**
 四舍五入到整数位
 */
@property (readonly) AZQuantityValue round0Value;

/**
 四舍五入到小数点后1位
 */
@property (readonly) AZQuantityValue round1Value;

/**
 四舍五入到小数点后2位
 */
@property (readonly) AZQuantityValue round2Value;

/**
 向下取整，忽略小数点后
 */
@property (readonly) AZQuantityValue floorValue;

/**
 向下取整，忽略小数点第1位后
 */
@property (readonly) AZQuantityValue floor1Value;

/**
 向下取整，忽略小数点第2位后
 */
@property (readonly) AZQuantityValue floor2Value;


/**
 根据类型自动四舍五入的值
 重量 - 0位
 长度 -
     米：0位
     公里：
     英里：2位
 能量 - 0位
 */
@property (readonly) AZQuantityValue roundValue;

- (NSString *)valueStringWithFormat:(NSString *)format;

@property (readonly) NSString *round0ValueString;
@property (readonly) NSString *round1ValueString;
@property (readonly) NSString *round2ValueString;
@property (readonly) NSString *floorValueString;
@property (readonly) NSString *floor1ValueString;
@property (readonly) NSString *floor2ValueString;

@property (readonly) NSString *roundValueString;

@end



@interface AZMassQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)massQuantityWithUnit:(AZQuantityUnit)unit
                               value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZMassQuantity *gram;
@property (readonly) AZMassQuantity *kilogram;
@property (readonly) AZMassQuantity *pound;
@property (readonly) AZMassQuantity *jin;

@end


@interface AZLengthQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)lengthQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZLengthQuantity *meter;
@property (readonly) AZLengthQuantity *kilometer;
@property (readonly) AZLengthQuantity *centimeter;
@property (readonly) AZLengthQuantity *inch;
@property (readonly) AZLengthQuantity *mile;
@property (readonly) AZLengthQuantity *foot;
@property (readonly) AZLengthQuantity *yard;

@end


@interface AZEnergyQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)energyQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZEnergyQuantity *calorie;
@property (readonly) AZEnergyQuantity *kilocalorie;

@end

@interface AZScalarQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)scalarQuantityWithUnit:(AZQuantityUnit)unitType
                                 value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZScalarQuantity *count;
@property (readonly) AZScalarQuantity *percent;

@end


@interface AZTimeQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)timeQuantityWithUnit:(AZQuantityUnit)unitType
                               value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZTimeQuantity *second;
@property (readonly) AZTimeQuantity *minute;
@property (readonly) AZTimeQuantity *hour;

@end

@interface AZSpeedQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)speedQuantityWithUnit:(AZQuantityUnit)unitType
                                value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZSpeedQuantity *kilometersPerHour;
@property (readonly) AZSpeedQuantity *milesPerHour;
@property (readonly) AZSpeedQuantity *meterPerSecond;
@property (readonly) AZSpeedQuantity *yardPerHour;

@property (readonly) AZPaceQuantity *pace;

@end


@interface AZPaceQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)paceQuantityWithUnit:(AZQuantityUnit)unitType
                               value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZPaceQuantity *secondsPerMeter;
@property (readonly) AZPaceQuantity *secondsPer100Meter;
@property (readonly) AZPaceQuantity *secondsPerKilometer;
@property (readonly) AZPaceQuantity *secondsPerMile;
@property (readonly) AZPaceQuantity *secondsPerYard;
@property (readonly) AZPaceQuantity *secondsPer100Yard;

@property (readonly) AZSpeedQuantity *speed;

@end


@interface AZTemperatureQuantity : AZQuantity

#pragma mark - Creation

+ (instancetype)temperatureQuantityWithUnit:(AZQuantityUnit)unitType
                                      value:(AZQuantityValue)value;

#pragma mark - Convert

@property (readonly) AZTemperatureQuantity *degreeCelsius;
@property (readonly) AZTemperatureQuantity *degreeFahrenheit;
@property (readonly) AZTemperatureQuantity *kelvin;

@end

