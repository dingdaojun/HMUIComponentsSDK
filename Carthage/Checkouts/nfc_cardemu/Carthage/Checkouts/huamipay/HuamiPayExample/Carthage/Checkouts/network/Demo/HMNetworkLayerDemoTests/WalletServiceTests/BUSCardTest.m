//  BUSCardTest.m
//  Created on 2018/6/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import WalletService;
@import OCMock;


@interface BUSCardTest : HMServiceTest

@end

@implementation BUSCardTest

- (void)setUp {
    [super setUp];
    
    HMServiceAPI.defaultDelegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testBindBusCard {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBindBusCard"];

    id<HMServiceAPIBUSCard> cardMock = OCMProtocolMock(@protocol(HMServiceAPIBUSCard));
    OCMStub([cardMock api_busCardID]).andReturn(@"2566914052");
    OCMStub([cardMock api_busCardCityCode]).andReturn(@"1551");
    OCMStub([cardMock api_busCardApplicationID]).andReturn(@"a0000000032300869807010000000000");
    OCMStub([cardMock api_busCardLastUpdateTime]).andReturn([NSDate date]);

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_bindWithDeviceID:@"edc712fffe1196ee"
                                                              card:cardMock
                                                   completionBlock:^(BOOL success, NSString *message) {

                                                       [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                              parameters:nil
                                                                                 success:success
                                                                                 message:message
                                                                                    data:nil];
                                                       [expectation fulfill];
                                                   }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUnnindBusCard {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testUnnindBusCard"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_unbindWithDeviceID:@"edc712fffe1196ee"
                                                              cardID:@"2566914052"
                                                     completionBlock:^(BOOL success, NSString *message) {

                                                         [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                parameters:nil
                                                                                   success:success
                                                                                   message:message
                                                                                      data:nil];
                                                         [expectation fulfill];
                                                     }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testRetrieveBusCard {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testRetrieveBusCard"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_retrieveWithDeviceID:@"edc712fffe1196ee"
                                                       completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCard>> *cards) {

                                                           [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                  parameters:nil
                                                                                     success:success
                                                                                     message:message
                                                                                        data:cards];

                                                           for (id<HMServiceAPIBUSCard> card in cards) {

                                                               NSLog(@"CardID: %@", card.api_busCardID);
                                                               NSLog(@"CardCityCode: %@", card.api_busCardCityCode);
                                                               NSLog(@"CardApplicationID: %@", card.api_busCardApplicationID);
                                                               NSLog(@"CardLastUpdateTime: %@", card.api_busCardLastUpdateTime);
                                                               NSLog(@"CardState is: %@", card.api_busCardStatus);
                                                           }
                                                           [expectation fulfill];
                                                       }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testBUSCardTransactionRecords {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testBUSCardTransactionRecords"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCard_transactionRecordWithCityID:@"1111"
                                                                      cardID:@"1111"
                                                                        type:HMServiceBUSCardTransactionRecordTypeConsumption
                                                                    nextTime:nil
                                                                       limit:10
                                                             completionBlock:^(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime) {
                                                                 for (id<HMServiceAPIBUSCardTransactionRecord> record in records) {

                                                                     NSLog(@" Amount %zd", record.api_busCardTransactionRecordAmount);
                                                                     NSLog(@" State %@", record.api_busCardTransactionRecordState);
                                                                     NSLog(@" Type %@", record.api_busCardTransactionRecordType);
                                                                     NSLog(@" Time %@", record.api_busCardTransactionRecordTime);
                                                                     NSLog(@" Location %@", record.api_busCardTransactionRecordLocation);
                                                                     NSLog(@" ServiceProvider %@", record.api_busCardTransactionRecordServiceProvider);

                                                                     NSLog(@"");
                                                                 }
                                                                 [expectation fulfill];
                                                             }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUploadBUSCardTransactionRecord {

    id<HMServiceAPIBUSCardTransactionRecord> recordMock = OCMProtocolMock(@protocol(HMServiceAPIBUSCardTransactionRecord));
    OCMStub([recordMock api_busCardTransactionRecordTime]).andReturn([NSDate date]);
    OCMStub([recordMock api_busCardTransactionRecordState]).andReturn(@"222");
    OCMStub([recordMock api_busCardTransactionRecordAmount]).andReturn(100);
    OCMStub([recordMock api_busCardTransactionRecordLocation]).andReturn(@"2222");
    OCMStub([recordMock api_busCardTransactionRecordServiceProvider]).andReturn(@"2222");
    OCMStub([recordMock api_busCardTransactionRecordType]).andReturn(@"222");

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadBUSCardTransactionRecord"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCard_uploadTransactionRecordWithCityID:@"1111"
                                                                            cardID:@"1111"
                                                                           records:@[recordMock]
                                                                   completionBlock:^(BOOL success, NSString * _Nullable message) {

                                                                       [expectation fulfill];
                                                                   }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}




- (void)testAllBUSCardCities {


    XCTestExpectation *expectation = [self expectationWithDescription:@"testAllBUSCardCities"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_citiesWithDeviceID:@"edc712fffe1196ee"
                                                     completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities) {

                                                         [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                parameters:nil
                                                                                   success:success
                                                                                   message:message
                                                                                      data:cities];

                                                         for (id<HMServiceAPIBUSCardCity> city in cities) {

                                                             NSLog(@" Name: %@", city.api_busCardCityName);
                                                             NSLog(@" ID: %@", city.api_busCardCityID);
                                                             NSLog(@" CardName: %@", city.api_busCardCityCardName);
                                                             NSLog(@" AID: %@", city.api_busCardCityAID);
                                                             NSLog(@" BusCode: %@", city.api_busCardCityBusCode);
                                                             NSLog(@" CardCode: %@", city.api_busCardCityCardCode);
                                                             NSLog(@" ServiceScope: %@", city.api_busCardCityServiceScope);
                                                             NSLog(@" OpenedImgUrl: %@", city.api_busCardCityOpenedImgUrl);
                                                             NSLog(@" UnopenedImgUrl: %@", city.api_busCardCityUnopenedImgUrl);
                                                             NSLog(@" HasSubCity: %d", city.api_busCardCityHasSubCity);
                                                             NSLog(@" CityOrderID: %@", city.api_busCardCityOrderID);
                                                             NSLog(@" CardStatus: %d", (int)city.api_busCardCityCardStatus);
                                                             NSLog(@" Status: %d", (int)city.api_busCardCityStatus);
                                                             NSLog(@" FetchApduMode: %@", city.api_busCardCityFetchApduMode);
                                                             NSLog(@" ParentCityID: %@", city.api_busCardCityParentCityID);
                                                             NSLog(@" VisibleGroups: %@", city.api_busCardCityVisibleGroups);
                                                             NSLog(@" XiaomiCardName: %@", city.api_busCardCityXiaomiCardName);
                                                             NSLog(@" XiaomiActionToken: %@", city.api_busCardCityXiaomiActionToken);
                                                             NSLog(@" XiaomiCardStatus: %d", (int)city.api_busCardCityXiaomiCardStatus);
                                                             NSLog(@" SupportApps: %@", city.api_busCardCitySupportApps);
                                                             NSLog(@" OpenTime: %@", city.api_busCardCityOpenTime);
                                                             NSLog(@" CardID: %@", city.api_busCardCityCardID);

                                                             NSLog(@"");
                                                         }

                                                         [expectation fulfill];
                                                     }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];

}

- (void)testBUSCardCity {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBUSCardCity"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_cityWithID:@"edc712fffe1196ee"
                                             completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIBUSCardCity> _Nullable city) {

                                                 [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                        parameters:nil
                                                                           success:success
                                                                           message:message
                                                                              data:city];
                                                 if (city) {
                                                     NSLog(@" Name: %@", city.api_busCardCityName);
                                                     NSLog(@" ID: %@", city.api_busCardCityID);
                                                     NSLog(@" CardName: %@", city.api_busCardCityCardName);
                                                     NSLog(@" AID: %@", city.api_busCardCityAID);
                                                     NSLog(@" BusCode: %@", city.api_busCardCityBusCode);
                                                     NSLog(@" CardCode: %@", city.api_busCardCityCardCode);
                                                     NSLog(@" ServiceScope: %@", city.api_busCardCityServiceScope);
                                                     NSLog(@" OpenedImgUrl: %@", city.api_busCardCityOpenedImgUrl);
                                                     NSLog(@" UnopenedImgUrl: %@", city.api_busCardCityUnopenedImgUrl);
                                                     NSLog(@" HasSubCity: %d", city.api_busCardCityHasSubCity);
                                                     NSLog(@" CityOrderID: %@", city.api_busCardCityOrderID);
                                                     NSLog(@" CardStatus: %d", (int)city.api_busCardCityCardStatus);
                                                     NSLog(@" Status: %d", (int)city.api_busCardCityStatus);
                                                     NSLog(@" FetchApduMode: %@", city.api_busCardCityFetchApduMode);
                                                     NSLog(@" ParentCityID: %@", city.api_busCardCityParentCityID);
                                                     NSLog(@" VisibleGroups: %@", city.api_busCardCityVisibleGroups);
                                                     NSLog(@" XiaomiCardName: %@", city.api_busCardCityXiaomiCardName);
                                                     NSLog(@" XiaomiActionToken: %@", city.api_busCardCityXiaomiActionToken);
                                                     NSLog(@" XiaomiCardStatus: %d", (int)city.api_busCardCityXiaomiCardStatus);
                                                     NSLog(@" SupportApps: %@", city.api_busCardCitySupportApps);
                                                     NSLog(@" OpenTime: %@", city.api_busCardCityOpenTime);
                                                     NSLog(@" CardID: %@", city.api_busCardCityCardID);

                                                     NSLog(@"");
                                                 }
                                                 [expectation fulfill];
                                             }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testBUSCardCities {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBUSCardCities"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_cityWithDeviceID:@"edc712fffe1196ee"
                                                   completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities) {

                                                       [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                              parameters:nil
                                                                                 success:success
                                                                                 message:message
                                                                                    data:cities];

                                                       for (id<HMServiceAPIBUSCardCity> city in cities) {

                                                           NSLog(@" Name: %@", city.api_busCardCityName);
                                                           NSLog(@" ID: %@", city.api_busCardCityID);
                                                           NSLog(@" CardName: %@", city.api_busCardCityCardName);
                                                           NSLog(@" AID: %@", city.api_busCardCityAID);
                                                           NSLog(@" BusCode: %@", city.api_busCardCityBusCode);
                                                           NSLog(@" CardCode: %@", city.api_busCardCityCardCode);
                                                           NSLog(@" ServiceScope: %@", city.api_busCardCityServiceScope);
                                                           NSLog(@" OpenedImgUrl: %@", city.api_busCardCityOpenedImgUrl);
                                                           NSLog(@" UnopenedImgUrl: %@", city.api_busCardCityUnopenedImgUrl);
                                                           NSLog(@" HasSubCity: %d", city.api_busCardCityHasSubCity);
                                                           NSLog(@" CityOrderID: %@", city.api_busCardCityOrderID);
                                                           NSLog(@" CardStatus: %d", (int)city.api_busCardCityCardStatus);
                                                           NSLog(@" Status: %d", (int)city.api_busCardCityStatus);
                                                           NSLog(@" FetchApduMode: %@", city.api_busCardCityFetchApduMode);
                                                           NSLog(@" ParentCityID: %@", city.api_busCardCityParentCityID);
                                                           NSLog(@" VisibleGroups: %@", city.api_busCardCityVisibleGroups);
                                                           NSLog(@" XiaomiCardName: %@", city.api_busCardCityXiaomiCardName);
                                                           NSLog(@" XiaomiActionToken: %@", city.api_busCardCityXiaomiActionToken);
                                                           NSLog(@" XiaomiCardStatus: %d", (int)city.api_busCardCityXiaomiCardStatus);
                                                           NSLog(@" SupportApps: %@", city.api_busCardCitySupportApps);
                                                           NSLog(@" OpenTime: %@", city.api_busCardCityOpenTime);
                                                           NSLog(@" CardID: %@", city.api_busCardCityCardID);

                                                           NSLog(@"");
                                                       }

                                                       [expectation fulfill];
                                                   }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testBusCompanyNotices {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBusCompanyNotices"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_busCompanyNoticeWithCompletionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices) {

        [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                               parameters:nil
                                  success:success
                                  message:message
                                     data:companyNotices];

        for (id<HMServiceAPIBUSCardCompanyNotice> companyNotice in companyNotices) {

            NSLog(@" Cities: %@", companyNotice.api_busCardCompanyNoticeCities);
            NSLog(@" Context: %@", companyNotice.api_busCardCompanyNoticeContext);
            NSLog(@" CrossBarUrl: %@", companyNotice.api_busCardCompanyNoticeCrossBarUrl);
            NSLog(@" ID: %@", companyNotice.api_busCardCompanyNoticeID);
            NSLog(@" StartTime: %@", companyNotice.api_busCardCompanyNoticeStartTime);
            NSLog(@" EndTime: %@", companyNotice.api_busCardCompanyNoticeEndTime);
            NSLog(@" UpdateTime: %@", companyNotice.api_busCardCompanyNoticeUpdateTime);
            NSLog(@" Type: %@", companyNotice.api_busCardCompanyNoticeTypes);
            NSLog(@" LoopType: %@", companyNotice.api_busCardCompanyNoticeLoopType);
            NSLog(@" AppVersions: %@", companyNotice.api_busCardCompanyNoticeAppVersions);
            NSLog(@" SupportCrossBarJump: %d", companyNotice.api_busCardCompanyNoticeSupportCrossBarJump);
            NSLog(@"");
        }

        [expectation fulfill];
    }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCityBusCompanyNotices {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testCityBusCompanyNotices"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCard_busCompanyNoticeWithCityID:@"9005"
                                                             completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices) {

                                                                 [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                        parameters:nil
                                                                                           success:success
                                                                                           message:message
                                                                                              data:companyNotices];

                                                                 for (id<HMServiceAPIBUSCardCompanyNotice> companyNotice in companyNotices) {

                                                                     NSLog(@" Cities: %@", companyNotice.api_busCardCompanyNoticeCities);
                                                                     NSLog(@" Context: %@", companyNotice.api_busCardCompanyNoticeContext);
                                                                     NSLog(@" CrossBarUrl: %@", companyNotice.api_busCardCompanyNoticeCrossBarUrl);
                                                                     NSLog(@" ID: %@", companyNotice.api_busCardCompanyNoticeID);
                                                                     NSLog(@" StartTime: %@", companyNotice.api_busCardCompanyNoticeStartTime);
                                                                     NSLog(@" EndTime: %@", companyNotice.api_busCardCompanyNoticeEndTime);
                                                                     NSLog(@" UpdateTime: %@", companyNotice.api_busCardCompanyNoticeUpdateTime);
                                                                     NSLog(@" Type: %@", companyNotice.api_busCardCompanyNoticeCities);
                                                                     NSLog(@" LoopType: %@", companyNotice.api_busCardCompanyNoticeLoopType);
                                                                     NSLog(@" AppVersions: %@", companyNotice.api_busCardCompanyNoticeAppVersions);
                                                                     NSLog(@" SupportCrossBarJump: %d", companyNotice.api_busCardCompanyNoticeSupportCrossBarJump);
                                                                     NSLog(@"");
                                                                 }

                                                                 [expectation fulfill];
                                                             }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


@end
