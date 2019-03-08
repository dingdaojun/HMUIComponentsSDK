//  BUSCardsBindingTest.m
//  Created on 2018/3/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import WalletService;
@import OCMock;

@interface BUSCardsBindingTest : HMServiceTest

@end

@implementation BUSCardsBindingTest

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

- (void)testTransactionRecords {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testTransactionRecords"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCardsBinding_transactionRecordWithCityID:@"1111"
                                                                              cardID:@"1111"
                                                                                type:HMServiceBindBUSCardsTransactionRecordTypeConsumption
                                                                            nextTime:nil
                                                                               limit:10
                                                                     completionBlock:^(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime) {

                                                                         [expectation fulfill];
                                                                     }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUploadTransactionRecord {

    id<HMServiceAPIBUSCardsTransactionRecord> recordMock = OCMProtocolMock(@protocol(HMServiceAPIBUSCardsTransactionRecord));
    OCMStub([recordMock api_busCardsTransactionRecordTime]).andReturn([NSDate date]);
    OCMStub([recordMock api_busCardsTransactionRecordState]).andReturn(@"222");
    OCMStub([recordMock api_busCardsTransactionRecordAmount]).andReturn(100);
    OCMStub([recordMock api_busCardsTransactionRecordLocation]).andReturn(@"2222");
    OCMStub([recordMock api_busCardsTransactionRecordServiceProvider]).andReturn(@"2222");
    OCMStub([recordMock api_busCardsTransactionRecordType]).andReturn(@"222");

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadTransactionRecord"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCardsBinding_uploadTransactionRecordWithCityID:@"1111"
                                                                                    cardID:@"1111"
                                                                                   records:@[recordMock]
                                                                           completionBlock:^(BOOL success, NSString * _Nullable message) {

                                                                               [expectation fulfill];
                                                                           }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testBindDevice {

    id<HMServiceAPIBUSCardsBindingCard> cardMock = OCMProtocolMock(@protocol(HMServiceAPIBUSCardsBindingCard));
    OCMStub([cardMock api_busCardsBindingCardID]).andReturn(@"2566914052");
    OCMStub([cardMock api_busCardsBindingCardCityCode]).andReturn(@"1551");
    OCMStub([cardMock api_busCardsBindingCardApplicationID]).andReturn(@"a0000000032300869807010000000000");

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBindDevice"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCardsBinding_bindWithDeviceID:@"c7ff16fffe6cec44"
                                                               deviceType:0
                                                                     card:cardMock
                                                          completionBlock:^(BOOL success, NSString *message) {

                                                              [expectation fulfill];
                                                          }];
    
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUnboundBUSCards {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUnboundBUSCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI busCardsBinding_unbindWithDeviceID:@"2222"
                                                                     cardID:@"2222"
                                                            completionBlock:^(BOOL success, NSString *message) {

                                                                [expectation fulfill];
                                                            }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUnboundAllBUSCards {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUnboundAllBUSCards"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    [serviceAPI busCardsBinding_unbindWithDeviceID:@"2222"
                                   completionBlock:^(BOOL success, NSString *message) {

                                       [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                              parameters:nil
                                                                 success:success
                                                                 message:message
                                                                    data:nil];
                                       [expectation fulfill];
                                   }];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testRetrieveBoundBUSCards {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testRetrieveBoundBUSCards"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_boundCardsWithDeviceID:@"asdasdasd"
                                                                 completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIBUSCardsBindingCard>> *cards) {

                                                                     [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                            parameters:nil
                                                                                               success:success
                                                                                               message:message
                                                                                                  data:cards];

                                                                     for (id<HMServiceAPIBUSCardsBindingCard> card in cards) {

                                                                         NSLog(@"CardID: %@", card.api_busCardsBindingCardID);
                                                                         NSLog(@"CardCityCode: %@", card.api_busCardsBindingCardCityCode);
                                                                         NSLog(@"CardApplicationID: %@", card.api_busCardsBindingCardApplicationID);
                                                                         NSLog(@"CardLastUpdateTime: %@", card.api_busCardsBindingCardLastUpdateTime);
                                                                         NSLog(@"CardState is: %d", (int)card.api_busCardsBindingCardStatus);
                                                                     }
                                                                     [expectation fulfill];
                                                                 }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testVerifyCaptcha {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testVerifyCaptcha"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_verifyCaptchaWithPhone:@"15105516107"
                                                                 completionBlock:^(BOOL success, NSInteger httpCode, NSString * _Nullable message) {

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

- (void)testBoundPhone {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testBoundPhone"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_boundPhone:@"15105516107"
                                                       verifyCaptcha:@"674758"
                                                     completionBlock:^(BOOL success, NSString * _Nullable message) {

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

- (void)testCitys {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testCitys"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_citysWithCompletionBlock:^(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsCity>> * _Nullable citys) {

        [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                               parameters:nil
                                  success:success
                                  message:message
                                     data:nil];


        for (id<HMServiceAPIBUSCardsCity> city in citys) {

            NSLog(@" Name: %@", city.api_busCardsCityName);
            NSLog(@" ID: %@", city.api_busCardsCityID);
            NSLog(@" CardName: %@", city.api_busCardsCityCardName);
            NSLog(@" AID: %@", city.api_busCardsCityAID);
            NSLog(@" BusCode: %@", city.api_busCardsCityBusCode);
            NSLog(@" CardCode: %@", city.api_busCardsCityCardCode);
            NSLog(@" ServiceScope: %@", city.api_busCardsCityServiceScope);
            NSLog(@" OpenedImgUrl: %@", city.api_busCardsCityOpenedImgUrl);
            NSLog(@" UnopenedImgUrl: %@", city.api_busCardsCityUnopenedImgUrl);
            NSLog(@" HasSubCity: %d", city.api_busCardsCityHasSubCity);
            NSLog(@" OpenTime: %@", city.api_busCardsCityOpenTime);

            NSLog(@"");
        }

        [expectation fulfill];
    }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCity {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testCity"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_cityWithID:@"0100"
                                                     completionBlock:^(BOOL success, NSString * _Nullable message, id<HMServiceAPIBUSCardCity> _Nullable city) {

                                                         [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                parameters:nil
                                                                                   success:success
                                                                                   message:message
                                                                                      data:nil];



                                                         [expectation fulfill];

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

                                                         [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                parameters:nil
                                                                                   success:success
                                                                                   message:message
                                                                                      data:city];
                                                     }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testOpenedCities {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOpenedCities"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_openedCitiesWithDeviceID:@"222"
                                                                   completionBlock:^(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable citys) {

                                                                       [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                              parameters:nil
                                                                                                 success:success
                                                                                                 message:message
                                                                                                    data:nil];


                                                                       for (id<HMServiceAPIBUSCardCity> city in citys) {

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

- (void)testConfiguration {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOpenedCities"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_retrieveWithCompletionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWalletConfiguration> configuration) {

        [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                               parameters:nil
                                  success:success
                                  message:message
                                     data:configuration];

        if (configuration) {
            NSLog(@"Pone: %@", configuration.api_busCardsCityConfigurationPone);
        }

        [expectation fulfill];
    }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCities {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testCities"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI busCardsBinding_cityWithDeviceID:@"edc712fffe1196ee"
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


@end
