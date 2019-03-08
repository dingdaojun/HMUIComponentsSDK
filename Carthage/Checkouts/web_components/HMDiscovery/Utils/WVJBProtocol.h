//  WVJBProtocol.h
//  Created on 2018/7/23
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

@protocol WVJBProtocol <NSObject>

@end

/** 微信订单 */
@protocol WVJBWechatPayOrder <WVJBProtocol>

@property (nonatomic, readonly) NSString *partnerId;
@property (nonatomic, readonly) NSString *prepayId;
@property (nonatomic, readonly) NSString *nonceStr;
@property (nonatomic, readonly) NSString *timeStamp;
@property (nonatomic, readonly) NSString *sign;
@property (nonatomic, readonly) NSString *package;

@end

/** 进入指定界面 */
@protocol WVJBNavigationPosition <WVJBProtocol>

@property (nonatomic, readonly) NSString *fallbackEvent;
@property (nonatomic, readonly) NSString *position;

@end

/** 同步表盘信息 */
@protocol WVJBSyncWatchDial <WVJBProtocol>

@property (nonatomic, readonly) NSString *skin_bin;
@property (nonatomic, readonly) long long skin_size;
@property (nonatomic, readonly) NSString *thumbnails;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *downloads;

@end
