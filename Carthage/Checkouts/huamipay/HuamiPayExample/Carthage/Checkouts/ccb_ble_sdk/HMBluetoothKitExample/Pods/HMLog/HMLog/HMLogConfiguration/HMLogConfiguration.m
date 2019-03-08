//
//  HMLogConfiguration.m
//  HMLog
//
//  Created by 李宪 on 26/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogConfiguration.h"
#import "HMLogConfiguration+Keys.h"

@interface HMLogConfiguration ()

@end

@implementation HMLogConfiguration

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.configurationValues];
}

- (NSString *)debugDescription {
    return [self description];
}

#pragma mark - public

+ (instancetype)defaultConfiguration {
    HMLogConfiguration *configuration = [[HMLogConfiguration alloc] init];
    
    return configuration;
}

#pragma mark - setters and getters

- (void)setConsoleTimeZone:(NSInteger)consoleTimeZone {
    
    NSParameterAssert(consoleTimeZone >= -12 && consoleTimeZone <= 12);
    
    [self setConfigurationValue:@(consoleTimeZone)
                         forKey:HMConfigurationKeyConsoleTimeZone];
}

- (void)setConsoleShouldHideSeperator:(BOOL)consoleShouldHideSeperator {
    [self setConfigurationValue:@(consoleShouldHideSeperator)
                         forKey:HMConfigurationKeyConsoleTimeZone];
}

- (void)setConsoleFilterLevels:(NSArray *)consoleFilterLevels {    
    [self setConfigurationValue:consoleFilterLevels
                         forKey:HMConfigurationKeyConsoleFilterLevels];
}

- (void)setConsoleFilterTags:(NSArray *)consoleFilterTags {
    [self setConfigurationValue:consoleFilterTags
                         forKey:HMConfigurationKeyConsoleFilterTags];
}

- (void)setDatabaseFilterLevels:(NSArray *)databaseFilterLevels {
    [self setConfigurationValue:databaseFilterLevels
                         forKey:HMConfigurationKeyDatabaseFilterLevels];
}

- (void)setDatabaseFilterTags:(NSArray *)databaseFilterTags {
    [self setConfigurationValue:databaseFilterTags
                         forKey:HMConfigurationKeyDatabaseFilterTags];
}

- (void)setDatabaseMaximumLogItems:(NSUInteger)databaseMaximumLogItems {
    [self setConfigurationValue:@(databaseMaximumLogItems)
                         forKey:HMConfigurationKeyDatabaseMaximumItemCount];
}

@end


#import <objc/runtime.h>

@implementation HMLogConfiguration (FilePath)

#pragma mark - public

+ (void)setRootDirectory:(NSString *)rootDirectory {
    objc_setAssociatedObject(self, "rootDirectory", rootDirectory, OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:rootDirectory]) {
        [fileManager createDirectoryAtPath:rootDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
}
+ (NSString *)rootDirectory {
    NSString *root = objc_getAssociatedObject(self, "rootDirectory");
    if (root) {
        return root;
    }

    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    // NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = directories.firstObject;
    root = [cacheDirectory stringByAppendingPathComponent:@"HMLog"];

    self.rootDirectory = root;

    return root;
}

+ (NSString *)pathWithFileName:(NSString *)fileName {
    return [[self rootDirectory] stringByAppendingPathComponent:fileName];
}

+ (NSArray *)filesInRootDirectory {
    
    NSString *root = [self rootDirectory];
    
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:root error:NULL];
    NSMutableArray *files = [NSMutableArray array];
    [subpaths enumerateObjectsUsingBlock:^(NSString *subpath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *fullPath = [root stringByAppendingPathComponent:subpath];
        
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                [files addObject:fullPath];
            }
        }
    }];
    
    return files;
}

@end
