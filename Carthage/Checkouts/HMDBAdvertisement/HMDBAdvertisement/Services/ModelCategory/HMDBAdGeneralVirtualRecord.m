//  HMDBAdGeneralVirtualRecord.m
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBAdGeneralVirtualRecord.h"
#import "HMDBAdGeneralResourceRecord+Protocol.h"

@interface HMDBAdGeneralVirtualRecord()

@property (nonatomic, readwrite)NSMutableArray <HMDBAdGeneralResourceRecord *> *virtualAdResource; // 广告资源

@end

@implementation HMDBAdGeneralVirtualRecord

- (instancetype)initWithProtocol:(id<HMDBAdGeneralProtocol>)protcol {
    self = [super init];
    
    if(self) {
        _generalAd = [[HMDBAdGeneralRecord alloc] init];
        _generalAd.adID = protcol.db_adID;
        _generalAd.adModuleType = protcol.db_adModuleType;
        _generalAd.adWebviewUrl = protcol.db_adWebviewUrl;
        _generalAd.adLogoWebviewUrl = protcol.db_adLogoWebviewUrl;
        _generalAd.adGeneralImage = protcol.db_adGeneralImage;
        _generalAd.adTitle = protcol.db_adTitle;
        _generalAd.adSubTitle = protcol.db_adSubTitle;
        
        if (protcol.db_adEndTime) {
            long long milSeconds = [protcol.db_adEndTime timeIntervalSince1970] * 1000;
            _generalAd.adEndTime = @(milSeconds);
        }
        
        _virtualAdResource = [NSMutableArray array];
        
        for (id<HMDBAdGeneralResourceProtocol> resource in protcol.db_adImages) {
            HMDBAdGeneralResourceRecord *record = [[HMDBAdGeneralResourceRecord alloc] initWithProtocol:resource resourceType:HMDBAdResourceTypeImage];
            [_virtualAdResource addObject:record];
        }
        
        for (id<HMDBAdGeneralResourceProtocol> resource in protcol.db_adColors) {
            HMDBAdGeneralResourceRecord *record = [[HMDBAdGeneralResourceRecord alloc] initWithProtocol:resource resourceType:HMDBAdResourceTypeColor];
            [_virtualAdResource addObject:record];
        }
        
    }
    
    return self;
}

- (instancetype)initWithRecord:(HMDBAdGeneralRecord *)generalRecord andResource:(NSArray<HMDBAdGeneralResourceRecord *> *)resource {
    self = [super init];
    
    if(self) {
        _generalAd = generalRecord;
        _virtualAdResource = [resource mutableCopy];
    }
    
    return self;
}

#pragma mark - HMDBAdGeneralProtocol
- (NSString *)db_adID {
    return _generalAd.adID;
}

- (HMDBAdModuleType)db_adModuleType {
    return _generalAd.adModuleType;
}

- (NSString *)db_adWebviewUrl {
    return _generalAd.adWebviewUrl;
}

- (NSString *)db_adLogoWebviewUrl {
    return _generalAd.adLogoWebviewUrl;
}

- (NSString *)db_adGeneralImage {
    return _generalAd.adGeneralImage;
}

- (NSString *)db_adTitle {
    return _generalAd.adTitle;
}

- (NSString *)db_adSubTitle {
    return _generalAd.adSubTitle;
}

- (NSDate *)db_adEndTime {
    if (!_generalAd.adEndTime) {
        return nil;
    }
    
    double timeInterval = [_generalAd.adEndTime longLongValue] / 1000.0;
    
    return [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
}

- (NSArray<id<HMDBAdGeneralResourceProtocol>> *)db_adImages {
    NSMutableArray *imageResource = [NSMutableArray array];
    
    for (HMDBAdGeneralResourceRecord *resource in _virtualAdResource) {
        if (resource.resourceType == HMDBAdResourceTypeImage) {
            [imageResource addObject:resource];
        }
    }
    
    return imageResource;
}

- (NSArray<id<HMDBAdGeneralResourceProtocol>> *)db_adColors {
    NSMutableArray *colorResource = [NSMutableArray array];
    
    for (HMDBAdGeneralResourceRecord *resource in _virtualAdResource) {
        if (resource.resourceType == HMDBAdResourceTypeColor) {
            [colorResource addObject:resource];
        }
    }
    
    return colorResource;
}

@end
