//
//  HMLogConfiguration+Keys.h
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogConfiguration.h"

#import "HMLogDefines.h"

// console keys
HM_EXTERN_KEY(HMConfigurationKeyConsoleTimeZone)
HM_EXTERN_KEY(HMConfigurationKeyConsoleHideSeperator)
HM_EXTERN_KEY(HMConfigurationKeyConsoleFilterLevels)
HM_EXTERN_KEY(HMConfigurationKeyConsoleFilterTags)

// database keys
HM_EXTERN_KEY(HMConfigurationKeyDatabaseFlushInterval)
HM_EXTERN_KEY(HMConfigurationKeyDatabaseFlushItemCount)
HM_EXTERN_KEY(HMConfigurationKeyDatabaseMaximumItemCount)
HM_EXTERN_KEY(HMConfigurationKeyDatabaseFilterLevels)
HM_EXTERN_KEY(HMConfigurationKeyDatabaseFilterTags)


@interface HMLogConfiguration (Keys)

@property (nonatomic, readonly, strong) NSDictionary<NSString *, id> *configurationValues;

- (id)configurationValueForKey:(NSString *)key;

- (void)setConfigurationValue:(id)value
                       forKey:(NSString *)key;

#pragma mark - convinience

- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSUInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
   
@end
