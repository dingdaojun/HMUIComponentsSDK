//  HMDBAdGeneralVirtualRecord.h
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>
#import "HMDBAdGeneralProtocol.h"
#import "HMDBAdGeneralRecord.h"
#import "HMDBAdGeneralResourceRecord.h"

@interface HMDBAdGeneralVirtualRecord : NSObject <HMDBAdGeneralProtocol>

@property (nonatomic, strong)HMDBAdGeneralRecord *generalAd; // 广告资源
@property (nonatomic, readonly)NSArray<HMDBAdGeneralResourceRecord *> *virtualAdResource; // 广告资源

- (instancetype)initWithProtocol:(id<HMDBAdGeneralProtocol>)protcol;

- (instancetype)initWithRecord:(HMDBAdGeneralRecord *)generalRecord andResource:(NSArray<HMDBAdGeneralResourceRecord *> *)resource;

@end
