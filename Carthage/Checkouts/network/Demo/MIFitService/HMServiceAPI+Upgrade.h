//
//  HMServiceAPI+Upgrade.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceAPIUpgradeType) {
    HMServiceAPIUpgradeTypeNormal       = 1,
    HMServiceAPIUpgradeTypeForce,
    HMServiceAPIUpgradeTypeGrey
};

@protocol HMServiceAPIUpgradeVersion <NSObject>

@property (nonatomic, assign, readonly) HMServiceAPIUpgradeType api_upgradeVersionType;
@property (nonatomic, copy, readonly) NSString *api_upgradeVersionSimplifiedChineseLog;
@property (nonatomic, copy, readonly) NSString *api_upgradeVersionTraditionalChineseLog;
@property (nonatomic, copy, readonly) NSString *api_upgradeVersionEnglishLog;

@end

@protocol HMServiceUpgradeAPI <HMServiceAPI>

/**
 检查升级版本信息
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=221
 */
- (id<HMCancelableAPI>)upgrade_newVersionWithVersionCode:(NSUInteger)versionCode
                                         completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIUpgradeVersion>version))completionBlock;

@end

@interface HMServiceAPI (Upgrade) <HMServiceUpgradeAPI>
@end
