//
//  HMLogConfiguration.h
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HMLogDefines.h"

@interface HMLogConfiguration : NSObject

+ (instancetype)defaultConfiguration;

// The time zone used for format date, value from -12 to 12, default is 8.
@property (nonatomic, assign) NSInteger consoleTimeZone;

// If console should hide seperator, default is YES.
@property (nonatomic, assign) BOOL consoleShouldHideSeperator;

// The log levels which can be output to console, if unset all log levels will be output to console. Default is nil.
@property (nonatomic, strong) NSArray *consoleFilterLevels;

// The log tags which can be output to console, if unset all log tags will be output to console. Default is nil.
@property (nonatomic, strong) NSArray *consoleFilterTags;

// The log levels which can be record in database, if unset all log levels will be output to database. Default is nil.
@property (nonatomic, strong) NSArray *databaseFilterLevels;

// The log tags which can be record in database, if unset all log tags will be output to database. Default is nil.
@property (nonatomic, strong) NSArray *databaseFilterTags;

// The maximum log items can be record in database
@property (nonatomic, assign) NSUInteger databaseMaximumLogItems;

@end


@interface HMLogConfiguration (FilePath)

@property (class, nonatomic, copy) NSString *rootDirectory;

+ (NSString *)pathWithFileName:(NSString *)fileName;
+ (NSArray *)filesInRootDirectory;

@end
