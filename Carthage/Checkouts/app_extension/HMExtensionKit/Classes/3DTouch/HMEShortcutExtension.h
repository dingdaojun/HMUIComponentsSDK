//
//  HMEShortcutExtension.h
//  MiFit
//
//  Created by jiangyang on 2017/5/23.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HMEShortcutItemType) {
    HMEShortcutItemTypeOutDoorRuning  = 0,
    HMEShortcutItemTypeInDoorRuning   = 1,
    HMEShortcutItemTypeCrossRiding    = 2,
    HMEShortcutItemTypeDiscovery      = 3,
};

extern NSString * const HMEShortcutTypeStringOutdoorrun;
extern NSString * const HMEShortcutTypeStringIndoorrun;
extern NSString * const HMEShortcutTypeStringOutdoorRidding;
extern NSString * const HMEShortcutTypeStringDiscovery;

@protocol HMEShortcutProtocol <NSObject>

/**
 Called by AppDelegate

 @param type HMEShortcutItemType
 */
- (void)shortcutOperationWithType:(HMEShortcutItemType)type;

@end


@interface HMEShortcutExtension : NSObject

+ (BOOL)isAvailable;

+ (void)addDynamicApplicationShortcutItems:(NSArray <NSNumber*> *)itemTypes
                                    titles:(NSArray <NSString*> *)titles
                                imageNames:(NSArray <NSString*> *)imageNames;

+ (HMEShortcutItemType)itemTypeForTypeString:(NSString*)typeString;

@end
