//
//  HMDBVersionMigration.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HMDBTableVersion_1.h"
#import "HMDBRecordVersion_1.h"
#import "HMDBTableVersion_2.h"
#import "HMDBRecordVersion_2.h"
#import <CTPersistance/CTPersistance.h>
#import "Target_MigrationTestDatabase.h"

@interface HMDBVersionMigration : XCTestCase

@property(nonatomic, strong) NSString *dataBase;
@end

@implementation HMDBVersionMigration

- (void)setUp {
    [super setUp];
    
    _dataBase = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MigrationTestDatabase_version.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:_dataBase]) {
        [fileManager removeItemAtPath:_dataBase error:nil];
    }
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVersion1_to_2 {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isMig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HMDBTableVersion_1 *table1 = [[HMDBTableVersion_1 alloc] init];
    
    CTPersistanceQueryCommand *queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:@"MigrationTestDatabase_version.sqlite"];
    NSArray <NSDictionary *> *originColumnInfo = [[queryCommand columnInfoWithTableName:@"current_weather" error:NULL] fetchWithError:NULL];
    XCTAssertEqual(originColumnInfo.count, 6);
    
    // 关闭数据库连接，模拟覆盖安装
    [[CTPersistanceDatabasePool sharedInstance] closeAllDatabase];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HMDBTableVersion_2 *table2 = [[HMDBTableVersion_2 alloc] init];
    queryCommand = [[CTPersistanceQueryCommand alloc] initWithDatabaseName:@"MigrationTestDatabase_version.sqlite"];
    originColumnInfo = [[queryCommand columnInfoWithTableName:@"current_weather" error:NULL] fetchWithError:NULL];
    XCTAssertEqual(originColumnInfo.count, 7);
}

@end
