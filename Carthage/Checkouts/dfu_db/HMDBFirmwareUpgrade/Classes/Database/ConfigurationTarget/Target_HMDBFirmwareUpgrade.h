//  Target_HMDBFirmwareUpgrade.h
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistance.h>

@interface Target_HMDBFirmwareUpgrade : NSObject<CTPersistanceConfigurationTarget>

- (NSString *)Action_filePath:(NSDictionary *)params;

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;

@end
