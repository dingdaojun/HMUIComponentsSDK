//  HMServiceAPI+ReactNative.h
//  Created on 2018/6/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

@protocol HMServiceAPIReactNativeFileInfo <NSObject>

@property (readonly) NSString *api_reactNativeFileMode;             // 文件的升级模式
@property (readonly) NSString *api_reactNativeFileKey;              // 文件的MO5值
@property (readonly) long long api_reactNativeFileSize;             // 文件大小
@property (readonly) NSString *api_reactNativeFileUrl;              // 文件下载的Url
@property (readonly) NSInteger api_reactNativeFileVersion;          // 升级包的版本好

@end

@protocol HMServiceReactNativeAPI <HMServiceAPI>

/**
 JavaScript授权
 @see http://aos-docs.private.mi-ae.cn/jsbridge/native-api/site/preVerifyJsApi/
 PS：考虑到参数来源于JavaScript，因此时间戳使用NSString类型。另外调用者需要判断参数合法性避免崩溃发生
 */
- (id<HMCancelableAPI>)reactNative_authorizeForJavaScriptWithAppKey:(NSString *)appKey
                                                          timestamp:(NSString *)timestamp
                                                              nonce:(NSString *)nonce
                                                          signature:(NSString *)signature
                                                             webURL:(NSString *)webURL
                                                           apiNames:(NSArray<NSString *> *)apiNames
                                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames))completionBlock;

/**
 *  @brief  更新RN
 *
 *  @param  modules         更新模块列表
 *
 *  @param  versions        版本信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://aos-docs.private.mi-ae.net/aos-api/discovery/rn_update/
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)reactNative_updateWithModules:(NSArray<NSString *> *)modules
                                            versions:(NSArray<NSString *> *)versions
                                     completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIReactNativeFileInfo> fileInfo))completionBlock;
@end


@interface HMServiceAPI (ReactNative) <HMServiceReactNativeAPI>
@end
