//
//  HMShortcutExtension.m
//  MiFit
//
//  Created by jiangyang on 2017/5/23.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMEShortcutExtension.h"

NSString * const HMEShortcutTypeStringOutdoorrun     = @"com.hmshortcut.outdoorrun";
NSString * const HMEShortcutTypeStringIndoorrun      = @"com.hmshortcut.indoorrun";
NSString * const HMEShortcutTypeStringOutdoorRidding = @"com.hmshortcut.outdoorridding";
NSString * const HMEShortcutTypeStringDiscovery      = @"com.hmshortcut.discovery";


@implementation HMEShortcutExtension

+ (BOOL)isAvailable
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f;
}

+ (void)addDynamicApplicationShortcutItems:(NSArray <NSNumber*> *)itemTypes
                                    titles:(NSArray <NSString*> *)titles
                                imageNames:(NSArray <NSString*> *)imageNames
{
    if (![HMEShortcutExtension isAvailable] || !itemTypes || !imageNames || !titles || itemTypes.count == 0 ||itemTypes.count != imageNames.count || itemTypes.count != titles.count) {
        return ;
    }
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < itemTypes.count; i++) {
        HMEShortcutItemType type = itemTypes[i].integerValue;
        NSString *typeString;
        switch (type) {
            case HMEShortcutItemTypeOutDoorRuning:
                typeString = HMEShortcutTypeStringOutdoorrun;
                break;
            case HMEShortcutItemTypeInDoorRuning:
                typeString = HMEShortcutTypeStringIndoorrun;
                break;
            case HMEShortcutItemTypeCrossRiding:
                typeString = HMEShortcutTypeStringOutdoorRidding;
                break;
            case HMEShortcutItemTypeDiscovery:
                typeString = HMEShortcutTypeStringDiscovery;
                break;
            default:
                typeString = @"";
                break;
        }
        UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc] initWithType:typeString localizedTitle:titles[i]];
        item.icon = [UIApplicationShortcutIcon iconWithTemplateImageName:imageNames[i]];
        [itemArray addObject:item];
    }
    [UIApplication sharedApplication].shortcutItems = [itemArray copy];
}

+ (HMEShortcutItemType)itemTypeForTypeString:(NSString*)typeString{
    HMEShortcutItemType type;
    if ([typeString isEqualToString:HMEShortcutTypeStringOutdoorrun]) {
        type = HMEShortcutItemTypeOutDoorRuning;
    } else if ([typeString isEqualToString:HMEShortcutTypeStringIndoorrun]) {
        type = HMEShortcutItemTypeInDoorRuning;
    } else if ([typeString isEqualToString:HMEShortcutTypeStringOutdoorRidding]) {
        type = HMEShortcutItemTypeCrossRiding;
    } else {
        type = HMEShortcutItemTypeDiscovery;
    }
    return type;
}

@end
