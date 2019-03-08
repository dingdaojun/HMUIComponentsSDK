//  HMDBAdGeneralResourceRecord+Protocol.h
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBAdGeneralResourceRecord.h"
#import "HMDBAdGeneralResourceProtocol.h"

typedef NS_ENUM(NSUInteger, HMDBAdResourceType) {
    HMDBAdResourceTypeImage = 0,  // 图片资源
    HMDBAdResourceTypeColor, // 颜色值
};

@interface HMDBAdGeneralResourceRecord (Protocol) <HMDBAdGeneralResourceProtocol>

- (instancetype)initWithProtocol:(id<HMDBAdGeneralResourceProtocol>)protcol resourceType:(HMDBAdResourceType)type;

@end
