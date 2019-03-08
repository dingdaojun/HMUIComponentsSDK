//  HMAdSleepDetailRecord.m
//  Created on 2018/5/30
//  Description 睡眠详情广告

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMAdSleepDetailRecord.h"

@implementation HMAdSleepDetailRecord

- (instancetype)init {
    self = [super init];

    if(self) {
        _advertisementID = @"";
        _logoImageURL = @"";
        _topImageURL = @"";
        _analysisImageURL = @"";
        _bannerImageURL = @"";
        _title = @"";
        _subTitle = @"";
        _backgroundColorHex = @"";
        _homeColorHex = @"";
        _themeColorHex = @"";
        _webviewLinkURL = @"";
        _logoLinkURL = @"";
    }

    return self;
}

@end
