//
//  HMWeatherLocationItem.m
//  MiFit
//
//  Created by luoliangliang on 2018/1/19.
//  Copyright © 2018年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMWeatherLocationItem.h"

@implementation HMWeatherLocationItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.locationKey = [aDecoder decodeObjectForKey:@"locationKey"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.currentLongitude = [aDecoder decodeFloatForKey:@"currentLongitude"];
        self.currentLatitude = [aDecoder decodeFloatForKey:@"currentLatitude"];
        self.affiliation = [aDecoder decodeObjectForKey:@"affiliation"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeObject:self.locationKey forKey:@"locationKey"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.currentLongitude forKey:@"currentLongitude"];
    [aCoder encodeFloat:self.currentLatitude forKey:@"currentLatitude"];
    [aCoder encodeObject:self.affiliation forKey:@"affiliation"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id)storeObj {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

+ (instancetype)fromStoreObj:(id)data {
    if ([data isKindOfClass:[NSData class]]) {
        id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([obj isKindOfClass:[self class]]) {
            return obj;
        }
    }
    return nil;
}

- (instancetype)initWithLocation:(id<HMServiceAPIWeatherLocationData>)locationData {
    self = [super init];
    if (self) {
        self.status = locationData.api_locationDataStatus;
        self.locationKey = locationData.api_locationDataKey;
        self.longitude = locationData.api_locationDataCoordinate.longitude;
        self.latitude = locationData.api_locationDataCoordinate.latitude;
        self.currentLongitude = -1;
        self.currentLatitude = -1;
        self.affiliation = locationData.api_locationDataAffiliation;
        self.name = locationData.api_locationDataName;
    }
    return self;
}
@end
