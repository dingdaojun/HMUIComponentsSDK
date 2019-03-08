//
//  @fileName  NSLocale+HMLocal.h
//  @abstract  本地化
//  @author    余彪 创建于 2017/5/17.
//  @revise    余彪 最后修改于 2017/5/17.
//  @version   当前版本号 1.0(2017/5/17).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSLocale (HMLocal)


/**
 判断是不是中国地区(Only 华米健康)
 
 @return YES ？是 ：不是
 */
+ (BOOL)isChinaRegion;

/**
 判断是不是中文语言(Only 华米健康)
 
 @return YES ？是 ：不是
 */
+ (BOOL)isChinaLanguage;


@end
