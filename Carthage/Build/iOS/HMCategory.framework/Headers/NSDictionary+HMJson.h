//
//  @fileName  NSDictionary+HMJson.h
//  @abstract  字典转JSON
//  @author    余彪 创建于 2017/5/10.
//  @revise    余彪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDictionary (HMJson)


/**
 转JSON

 @param isFormat 是否去掉无用的符号(回车\换行\跳格)
 @return NSString
 */
- (NSString *)toJSON:(BOOL)isFormat;

/**
 将Json转NSDictionary

 @param jsonString json
 @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
