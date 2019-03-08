//  HMAdSleepDetailRecord+Protocol.m
//  Created on 2018/5/31
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMAdSleepDetailRecord+Protocol.h"

@implementation HMAdSleepDetailRecord (Protocol)

- (instancetype)initWithProtocol:(id <HMDBAdSleepDetailProtocol> )protocol {
    self = [super init];

    if (self) {
        self.advertisementID = protocol.db_advertisementID;
        self.logoImageURL = protocol.db_logoImageURL;
        self.topImageURL = protocol.db_topImageURL;
        self.analysisImageURL = protocol.db_analysisImageURL;
        self.bannerImageURL = protocol.db_bannerImageURL;
        self.title = protocol.db_title;
        self.subTitle = protocol.db_subTitle;
        self.backgroundColorHex = protocol.db_backgroundColorHex;
        self.homeColorHex = protocol.db_homeColorHex;
        self.themeColorHex = protocol.db_themeColorHex;
        self.webviewLinkURL = protocol.db_webviewLinkURL;
        self.logoLinkURL = protocol.db_logoLinkURL;

        if (protocol.db_endDate) {
            long long endMilliseconds = [protocol.db_endDate timeIntervalSince1970] * 1000;
            self.endMilliseconds = @(endMilliseconds);
        }
    }

    return self;
}

#pragma mark - HMDBAdSleepDetailProtocol
// 广告ID
- (NSString *)db_advertisementID {
    return self.advertisementID;
}

// 客户logo
- (NSString *)db_logoImageURL {
    return self.logoImageURL;
}

// 顶部背景图
- (NSString *)db_topImageURL {
    return self.topImageURL;
}

// 质量分析背景图
- (NSString *)db_analysisImageURL {
    return self.analysisImageURL;
}

// 通栏banner图
- (NSString *)db_bannerImageURL {
    return self.bannerImageURL;
}

// 广告标题
- (NSString *)db_title {
    return self.title;
}

// 广告副标题
- (NSString *)db_subTitle {
    return  self.subTitle;
}

// 颜色值十六进制
- (NSString *)db_backgroundColorHex {
    return  self.backgroundColorHex;
}

// home 颜色值
- (NSString *)db_homeColorHex {
    return self.homeColorHex;
}

// theme 颜色值
- (NSString *)db_themeColorHex {
    return self.themeColorHex;
}

// 广告点击跳转地址
- (NSString *)db_webviewLinkURL {
    return self.webviewLinkURL;
}

// Logo 点击跳转地址
- (NSString *)db_logoLinkURL {
    return self.logoLinkURL;
}

// 广告结束时间
- (NSDate *)db_endDate {
    if(self.endMilliseconds) {
        double seconds = [self.endMilliseconds longLongValue] / 1000.0;
        return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    }

    return  nil;
}

@end
