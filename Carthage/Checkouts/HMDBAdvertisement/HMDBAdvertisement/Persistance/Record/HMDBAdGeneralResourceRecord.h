//  HMDBAdGeneralResourceRecord.h
//  Created on 2018/7/6
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <CTPersistance/CTPersistance.h>

@interface HMDBAdGeneralResourceRecord : CTPersistanceRecord

@property (copy, nonatomic) NSNumber *identifier;   // 数据库自生成主键
@property (assign, nonatomic) NSInteger resourceType;  // 资源类型
@property (copy, nonatomic) NSString *resourceValue;    // 资源值
@property (copy, nonatomic) NSString *displayPosition; // 资源展示位置
@property (copy, nonatomic) NSNumber *generalID;  // 广告主表 ID

@end
