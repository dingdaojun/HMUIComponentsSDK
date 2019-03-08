//  HMDBAdGeneralResourceRecord+Protocol.m
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBAdGeneralResourceRecord+Protocol.h"

@implementation HMDBAdGeneralResourceRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBAdGeneralResourceProtocol>)protcol resourceType:(HMDBAdResourceType)type {
    self = [super init];
    
    if (self) {
        self.resourceType = type;
        self.resourceValue = protcol.db_resourceValue;
        self.displayPosition = protcol.db_displayPositon;
    }
    
    return self;
}

#pragma mark - HMDBAdGeneralResourceProtocol
- (NSString *)db_resourceValue {
    return self.resourceValue;
}

- (NSString *)db_displayPositon {
    return self.displayPosition;
}

@end
