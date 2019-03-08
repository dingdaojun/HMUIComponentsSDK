//
//  HMDatabaseLogger.m
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMDatabaseLogger.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <sqlite3.h>

#import "HMLogItem.h"



static NSString * const kDBFileName             = @"hmlog.db";
static NSString * const kLogItemTableName       = @"log_item";


@interface HMDatabaseLogger () {
    sqlite3 *db;
}

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#else
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#endif  /* OS_OBJECT_USE_OBJC */

@property (nonatomic, strong) NSMutableArray<HMLogItem *> *cachedItems;

@property (nonatomic, assign) NSTimeInterval lastFlushTime;

// 最大缓存日志记录条数
@property (nonatomic, assign) NSUInteger flushItemCount;

// 最小记录日志时间间隔
@property (nonatomic, assign) NSTimeInterval flushInterval;

@end

@implementation HMDatabaseLogger

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("HMDatabaseLogger.ioQueue", DISPATCH_QUEUE_SERIAL);

#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(didReceiveMemoryWarning)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(willResignActive)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        
#endif  /* TARGET_OS_IPHONE */

        self.flushInterval      = 10;
        self.flushItemCount     = 10;
        self.maximumItemCount   = 100000;
    }

    return self;
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_ioQueue);
#endif
    
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif  /* TARGET_OS_IPHONE */
}

#if TARGET_OS_IPHONE

- (void)didReceiveMemoryWarning {
    
    dispatch_async(_ioQueue, ^{
        [self flush];
    });
}

- (void)willResignActive {
    
    dispatch_async(_ioQueue, ^{
        [self flush];
    });
}

#endif  /* TARGET_OS_IPHONE */


- (BOOL)shouldRecordItem:(HMLogItem *)item {
    
    NSNumber *levelValue = @(item.level);
    if (self.filterLevels.count > 0 &&
        ![self.filterLevels containsObject:levelValue]) {
        return NO;
    }
    
    if (self.filterTags.count > 0 &&
        ![self.filterTags containsObject:item.tag]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - sqlite

- (BOOL)executeSQL:(NSString *)sql {
    
    int ret = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (SQLITE_OK != ret) {
        sqlite3_close(db);
        db = NULL;
        return NO;
    }
    
    return YES;
}

- (BOOL)createLogItemTable {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS "
    "%@"
    "(ID INTEGER PRIMARY KEY AUTOINCREMENT,"
    "DATE TIMESTAMP,"
    "LEVEL INTEGER,"
    "TAG TEXT,"
    "TRACE TEXT,"
    "CONTENT TEXT"
    ")";
    sql = [NSString stringWithFormat:sql, kLogItemTableName];
    
    return [self executeSQL:sql];
}

- (BOOL)openDB {
    
    if (NULL != db) {
        return YES;
    }
    
    int ret = sqlite3_open(self.path.UTF8String, &db);
    if (SQLITE_OK != ret) {
        return NO;
    }
    
    if (![self createLogItemTable]) {
        return NO;
    }

    return YES;
}

- (void)closeDB {
    
    if (NULL == db) {
        return;
    }
    
    sqlite3_close(db);
    db = NULL;
}

- (BOOL)insertLogItems:(NSArray<HMLogItem *> *)items {
    
    NSString *sql = @"INSERT INTO '%@' ('DATE', 'LEVEL', 'TAG', 'TRACE', 'CONTENT') VALUES ";
    sql = [NSString stringWithFormat:sql, kLogItemTableName];
    
    NSMutableArray *valueSQLs = [NSMutableArray new];
    for (HMLogItem *item in items) {
        
        NSString *valueSQL = [NSString stringWithFormat:@"('%lld', '%d', '%@', '%@', '%@')",
                              (long long)(item.time.timeIntervalSince1970 * 1000),
                              (int)item.level,
                              item.tag,
                              [item.function stringByAppendingFormat:@"- %04d -", (int)item.line],
                              item.content];
        [valueSQLs addObject:valueSQL];
    }
    
    NSString *valueSQL = [valueSQLs componentsJoinedByString:@", "];
    sql = [sql stringByAppendingString:valueSQL];
    
    if (![self executeSQL:sql]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)removeOldestItemsInDatabase {
    
    NSString *sql = @"delete from %@ where (select count(ID) from %@)> %d and ID in (select ID from %@ order by ID desc limit (select count(ID) from %@) offset %d)";
    sql = [NSString stringWithFormat:sql, kLogItemTableName, kLogItemTableName, (int)self.maximumItemCount, kLogItemTableName, kLogItemTableName, (int)self.maximumItemCount];
    
    int ret = [self executeSQL:sql];
    if (SQLITE_OK != ret) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Flush

- (BOOL)shouldFlush {
    
    if (self.cachedItems.count == 0) {
        return NO;
    }
    
    for (HMLogItem *item in self.cachedItems) {
        if (item.level >= HMLogLevelError) {
            return YES;
        }
    }
    
    if (self.cachedItems.count > self.flushItemCount) {
        return YES;
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    if (time - self.lastFlushTime > self.flushInterval) {
        return YES;
    }
    
    return NO;
}

- (void)flush {
    
    if (![self openDB]) {
        return;
    }
    
    self.lastFlushTime = [NSDate date].timeIntervalSince1970;
    
    if (self.cachedItems.count == 0) {
        return;
    }
    
    [self insertLogItems:self.cachedItems];
    [self.cachedItems removeAllObjects];
    [self removeOldestItemsInDatabase];
    
    [self closeDB];
}

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {
    
    dispatch_async(_ioQueue, ^{

        if (![self shouldRecordItem:item]) {
            return;
        }

        [self.cachedItems addObject:item];

        if ([self shouldFlush]) {
            [self flush];
        }
    });
}

#pragma mark - setters and getters

- (NSMutableArray<HMLogItem *> *)cachedItems {
    if (!_cachedItems) {
        _cachedItems = [NSMutableArray new];
    }
    return _cachedItems;
}

- (NSString *)path {
    if (_path.length == 0) {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = directories.firstObject;
        NSString *rootDirectory = [cacheDirectory stringByAppendingPathComponent:@"HMLog"];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:rootDirectory]) {
            [fileManager createDirectoryAtPath:rootDirectory
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:NULL];
        }

        _path = [rootDirectory stringByAppendingPathComponent:kDBFileName];
    }
    return _path;
}

@end


@implementation HMDatabaseLogger (Query)

- (NSArray<HMLogItem *> *)queryLogItems {
#ifdef DEBUG
    return [self queryLogItemsByLevels:nil];
#else
    return nil;
#endif
}

- (NSArray<HMLogItem *> *)queryLogItemsWithLevelSet:(NSSet<NSNumber *> *)levelSet {
#ifdef DEBUG
    levelSet = [levelSet objectsPassingTest:^BOOL(NSNumber * _Nonnull number, BOOL * _Nonnull stop) {
        HMLogLevel level = (HMLogLevel)number.unsignedIntegerValue;
        return ( (level >= HMLogLevelVerbose) && (level <= HMLogLevelFatal) );
    }];
    NSArray<NSNumber *> *levels = levelSet.allObjects;
    return [self queryLogItemsByLevels:levels];
#else
    return nil;
#endif
}

- (NSArray<HMLogItem *> *)queryLogItemsByLevels:(NSArray<NSNumber *> *)levels {
    NSParameterAssert(levels.count <= 6);
    NSString *sql = nil;
    if (levels.count == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@", kLogItemTableName];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE LEVEL = ", kLogItemTableName];
    }

    for (NSUInteger idx = 0; idx < levels.count; idx++) {
        NSUInteger level = levels[idx].unsignedIntegerValue;
        if (level < HMLogLevelVerbose || level > HMLogLevelFatal) {
            return nil;
        }

        if (idx != (levels.count - 1)) {
            sql = [sql stringByAppendingFormat:@"%lu OR LEVEL = ",(unsigned long)level];
        } else {
            sql = [sql stringByAppendingFormat:@"%lu",(unsigned long)level];
        }
    }

    __block NSArray<HMLogItem *> *logItems = [NSArray array];

    dispatch_sync(_ioQueue, ^{
        if (![self openDB]) {
            return;
        }

        sqlite3_stmt *stmt = nil;
        int ret = sqlite3_prepare_v2(self->db, sql.UTF8String, -1, &stmt, NULL);
        if (ret == SQLITE_OK) {
            for (int i = 0; i < levels.count ; i++) {
                sqlite3_bind_int(stmt, i, levels[i].intValue);
            }
            logItems = [self itemsFromStmt:stmt];
        }
        sqlite3_finalize(stmt);
    });

    return logItems;
}

- (NSArray<HMLogItem *> *)itemsFromStmt:(sqlite3_stmt *)stmt {
    NSMutableArray *logItems = [NSMutableArray arrayWithCapacity:0];

    while (sqlite3_step(stmt) == SQLITE_ROW) {
        char *dateChar = (char *)sqlite3_column_text(stmt, 1);
        int level = sqlite3_column_int(stmt, 2);
        char *tagChar = (char *)sqlite3_column_text(stmt, 3);
        char *traceChar = (char *)sqlite3_column_text(stmt, 4);
        char *contentChar = (char *)sqlite3_column_text(stmt, 5);

        NSString *dateStr = [NSString stringWithUTF8String:dateChar];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(dateStr.longLongValue / 1000)];

        NSString *tag = [NSString stringWithUTF8String:tagChar];
        NSArray *traces = [[NSString stringWithUTF8String:traceChar] componentsSeparatedByString:@"-"];

        //默认至少包含函数名和方法所在行数
        if (traces.count < 2) {
            continue;
        }
        NSString *line = traces.lastObject ?: @"";
        NSString *function = traces[traces.count - 2] ?: @"";

        NSString *content = [NSString  stringWithUTF8String:contentChar];
        HMLogItem *item = [HMLogItem itemWithTime:date
                                             file:@""
                                             line:(NSUInteger)line.integerValue
                                         function:function
                                            level:(HMLogLevel)level
                                              tag:tag
                                          content:content
                                       stackLevel:0
                                     dataFileName:nil
                                             data:nil];
        [logItems addObject:item];
    }

    return logItems.copy;
}

@end
