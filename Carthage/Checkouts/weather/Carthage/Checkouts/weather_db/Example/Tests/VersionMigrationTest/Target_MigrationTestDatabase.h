//
//  Target_MigrationTestDatabase.h
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistance.h>

@interface Target_MigrationTestDatabase : NSObject<CTPersistanceConfigurationTarget>

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;

@end
