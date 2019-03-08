//
//  HMIDRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <DDWebService/WSRequestTask.h>
#import "HMAccountTools.h"
#import "HMAccountConfig.h"
#import "HMIDConstants.h"

@interface HMIDRequestTask : WSRequestTask

/**
 解析服务器返回的原始数据

 @param infoDict 服务器返回的数据
 */
- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict NS_REQUIRES_SUPER;

@end
