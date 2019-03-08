//  WalletTest.m
//  Created on 2018/3/17
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import WalletService;
@import OCMock;

@interface WalletTest : HMServiceTest

@end

@implementation WalletTest

- (void)setUp {
    [super setUp];
    HMServiceAPI.defaultDelegate = self;

}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {

}

- (void)testOrderFee {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOrderFee"];

    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              wallet_orderFeeWithCityID:@"9005"
                              orderType:HMServiceWalletOrderTypeOpenCardAndRecharge
                              xiaomiCardName:@"BMAC_MOT"
                              completionBlock:^(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderFeeProtocol>> *orderFees) {


                                  for (id<HMServiceAPIWalletOrderFeeProtocol>orderFee in  orderFees) {

                                      NSLog(@" FeeID  %@", orderFee.api_walletOrderFeeID);

                                      NSLog(@" OpenCard  %zd", orderFee.api_walletOrderFeeOpenCard);
                                      NSLog(@" Shiftin  %zd", orderFee.api_walletOrderFeeShiftin);
                                      NSLog(@" Shiftout  %zd", orderFee.api_walletOrderFeeShiftout);
                                      NSLog(@" Recharges  %zd", orderFee.api_walletOrderFeeRecharges);
                                      NSLog(@" DiscountedOpenCard  %zd", orderFee.api_walletOrderFeeDiscountedOpenCard);
                                      NSLog(@" DiscountedShiftin  %zd", orderFee.api_walletOrderFeeDiscountedShiftin);
                                      NSLog(@" DiscountedShiftout  %zd", orderFee.api_walletOrderFeeDiscountedShiftout);
                                      NSLog(@" DiscountedRecharges  %zd", orderFee.api_walletOrderFeeDiscountedRecharges);
                                      NSLog(@"");
                                  }

                                  [expectation fulfill];
                              }];
    [api printCURL];

    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testOrder {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOrder"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];

    id<HMCancelableAPI>api = [serviceAPI wallet_orderWithCityID:@"0371"
                                                          feeID:nil
                                                      orderType:HMServiceWalletOrderTypeRecharge
                                                 paymentChannel:HMServiceWalletOrderPaymentChannelTestAlipay
                                                  paymentAmount:1
                                                        loction:nil
                                                completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletOrderProtocol> order) {

                                                    if (!order) {
                                                        [expectation fulfill];
                                                        return;
                                                    }

                                                    NSLog(@" ID  %@", order.api_walletOrderID);
                                                    NSLog(@" Expire  %@", order.api_walletOrderExpire);
                                                    NSLog(@" SignedData  %@", order.api_walletOrderSignedData);
                                                    NSLog(@" Source  %@", order.api_walletOrderSource);
                                                    NSLog(@" PayGateway  %@", order.api_walletOrderPayGateway);
                                                    NSLog(@" PayUrl  %@", order.api_walletOrderPayUrl);
                                                    NSLog(@" Url  %@", order.api_walletOrderUrl);

                                                    [expectation fulfill];
                                                }];


    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testOrderList {

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    XCTestExpectation *expectation = [self expectationWithDescription:@"testOrderList"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];

    id<HMCancelableAPI>api = [serviceAPI wallet_orderListWithCityID:@"9005"
                                                     xiaomiCardName:@"京津冀互联互通卡"
                                                          startDate:[NSDate dateWithTimeIntervalSince1970:time - 10000]
                                                            endDate:[NSDate dateWithTimeIntervalSince1970:time ]
                                                              count:100
                                                      orderCategory:HMServiceWalletOrderCategoryAll
                                                    completionBlock:^(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderDetailProtocol>> *orderDetails) {

                                                        if (orderDetails.count == 0) {
                                                            [expectation fulfill];

                                                            return;
                                                        }

                                                        for (id<HMServiceAPIWalletOrderDetailProtocol> orderDetail in orderDetails) {

                                                            NSLog(@"ID  %@", orderDetail.api_walletOrderDetailID);
                                                            NSLog(@"PaymentChannel  %ld", orderDetail.api_walletOrderDetailPaymentChannel);
                                                            NSLog(@"Status  %ld", orderDetail.api_walletOrderDetailStatus);
                                                            NSLog(@"StatusDescription  %@", orderDetail.api_walletOrderDetailStatusDescription);
                                                            NSLog(@"Amount  %ld", orderDetail.api_walletOrderDetailAmount);
                                                            NSLog(@"Time  %@", orderDetail.api_walletOrderDetailTime);
                                                            NSLog(@"SerialNumber  %@", orderDetail.api_walletOrderDetailSerialNumber);
                                                            NSLog(@"CityID  %@", orderDetail.api_walletOrderDetailCityID);

                                                            NSLog(@" XiaomiCityID  %@", orderDetail.api_walletOrderDetailXiaomiCityID);
                                                            NSLog(@" ActionToken  %@", orderDetail.api_walletOrderDetailActionToken);
                                                            NSLog(@" OrderID  %@", orderDetail.api_walletOrderDetailOrderID);
                                                            NSLog(@" OrderSource  %@", orderDetail.api_walletOrderDetailOrderSource);
                                                            NSLog(@" PayTime  %@", orderDetail.api_walletOrderDetailPayTime);
                                                            NSLog(@" XiamiCardName  %@", orderDetail.api_walletOrderDetailXiamiCardName);

                                                            NSLog(@"");
                                                        }
                                                        [expectation fulfill];
                                                    }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testOrderDetail {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOrderDetail"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];

    id<HMCancelableAPI>api = [serviceAPI wallet_orderDetailWithOrderID:@"20180613194837087007021610674065"
                                                       completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletOrderDetailProtocol> orderDetail) {

                                                           if (!orderDetail) {
                                                               [expectation fulfill];
                                                               return;
                                                           }

                                                           NSLog(@"ID  %@", orderDetail.api_walletOrderDetailID);
                                                           NSLog(@"PaymentChannel  %ld", orderDetail.api_walletOrderDetailPaymentChannel);
                                                           NSLog(@"Status  %ld", orderDetail.api_walletOrderDetailStatus);
                                                           NSLog(@"StatusDescription  %@", orderDetail.api_walletOrderDetailStatusDescription);
                                                           NSLog(@"Amount  %ld", orderDetail.api_walletOrderDetailAmount);
                                                           NSLog(@"Time  %@", orderDetail.api_walletOrderDetailTime);
                                                           NSLog(@"SerialNumber  %@", orderDetail.api_walletOrderDetailSerialNumber);
                                                           NSLog(@"CityID  %@", orderDetail.api_walletOrderDetailCityID);

                                                           NSLog(@" XiaomiCityID  %@", orderDetail.api_walletOrderDetailXiaomiCityID);
                                                           NSLog(@" ActionToken  %@", orderDetail.api_walletOrderDetailActionToken);
                                                           NSLog(@" OrderID  %@", orderDetail.api_walletOrderDetailOrderID);
                                                           NSLog(@" OrderSource  %@", orderDetail.api_walletOrderDetailOrderSource);
                                                           NSLog(@" PayTime  %@", orderDetail.api_walletOrderDetailPayTime);
                                                           NSLog(@" XiamiCardName  %@", orderDetail.api_walletOrderDetailXiamiCardName);

                                                           [expectation fulfill];
                                                       }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testOrderRefund {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testOrderRefund"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_refundWithOrderID:@"00287310010022018031715582840823"
                                                  completionBlock:^(NSString *status, NSString *message) {

                                                      [expectation fulfill];
                                                  }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testAPDU {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testAPDU"];


    id<HMServiceAPIWalletOrderRequestAPDUProtocol> apduCommandMock = OCMProtocolMock(@protocol(HMServiceAPIWalletOrderRequestAPDUProtocol));
    OCMStub([apduCommandMock api_walletOrderRequestAPDUAid]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUBalance]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUCityID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUCardNumber]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUXiaomiCityID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUExtraInfo]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUAid]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUFetchMode]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUOrderToken]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUOrderID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUType]).andReturn(HMServiceWalletInstructionTypeLoad);

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];

    id<HMCancelableAPI>api = [serviceAPI wallet_APDUWithProtocol:apduCommandMock
                                                 completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDUResult) {

                                                     if (!APDUResult) {
                                                         [expectation fulfill];
                                                         return;
                                                     }

                                                     [expectation fulfill];
                                                 }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testNextAPDU {

    NSMutableArray *apduCommandMocks = [NSMutableArray array];

    for (NSInteger i = 0; i < 10; i++) {
        NSString *indexString = [NSString stringWithFormat:@"%ld", i];

        id<HMServiceAPIWalletOrderAPDUCommandProtocol> apduCommandMock = OCMProtocolMock(@protocol(HMServiceAPIWalletOrderAPDUCommandProtocol));
        OCMStub([apduCommandMock api_walletOrderAPDUIndex]).andReturn(indexString);
        OCMStub([apduCommandMock api_walletOrderAPDUCommand]).andReturn(@"22");
        OCMStub([apduCommandMock api_walletOrderAPDUCheckCode]).andReturn(@"22");
        OCMStub([apduCommandMock api_walletOrderAPDUResult]).andReturn(@"22");
        [apduCommandMocks addObject:apduCommandMock];
    }

    id<HMServiceAPIWalletOrderAPDUProtocol> apduMock = OCMProtocolMock(@protocol(HMServiceAPIWalletOrderAPDUProtocol));
    OCMStub([apduMock api_walletOrderAPDUSession]).andReturn(@"222");
    OCMStub([apduMock api_walletOrderAPDUNextStep]).andReturn(@"222");
    OCMStub([apduMock api_walletOrderAPDUCommands]).andReturn(apduCommandMocks);


    id<HMServiceAPIWalletOrderRequestAPDUProtocol> apduCommandMock = OCMProtocolMock(@protocol(HMServiceAPIWalletOrderRequestAPDUProtocol));
    OCMStub([apduCommandMock api_walletOrderRequestAPDUAid]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUBalance]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUCityID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUCardNumber]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUXiaomiCityID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUExtraInfo]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUAid]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUFetchMode]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUOrderToken]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUOrderID]).andReturn(@"");
    OCMStub([apduCommandMock api_walletOrderRequestAPDUType]).andReturn(HMServiceWalletInstructionTypeLoad);


    XCTestExpectation *expectation = [self expectationWithDescription:@"testNextAPDU"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_APDUWithResult:apduMock
                                                          APDU:apduCommandMock
                                                  resultSucess:YES
                                               completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDU) {

                                                   if (!APDU) {
                                                       [expectation fulfill];
                                                       return;
                                                   }

                                                   NSLog(@"session  %@", APDU.api_walletOrderAPDUSession);
                                                   NSLog(@"nextStep  %@", APDU.api_walletOrderAPDUNextStep);

                                                   for (id<HMServiceAPIWalletOrderAPDUCommandProtocol> command in APDU.api_walletOrderAPDUCommands) {

                                                       NSLog(@"Index  %@", command.api_walletOrderAPDUIndex);
                                                       NSLog(@"Command  %@", command.api_walletOrderAPDUCommand);
                                                       NSLog(@"CheckCode  %@", command.api_walletOrderAPDUCheckCode);
                                                       NSLog(@"Result  %@", command.api_walletOrderAPDUResult);
                                                   }

                                                   [expectation fulfill];
                                               }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testLingnanCard {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testInstalledCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.84116554260254, 117.1313934326172);
    id<HMCancelableAPI>api = [serviceAPI wallet_lingnanCardsWithCoordination:coordinate
                                                                 phoneNumber:@""
                                                                      userIP:@""
                                                             completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletLingnanCardsProtocol> cards) {
                                                                 id<HMServiceAPIWalletLingnanCardCityProtocol> recommendedCity = cards.api_walletLingnanCardsRecommendedCity ;
                                                                 NSArray<id<HMServiceAPIWalletLingnanCardCityProtocol>> *availableCitys = cards.api_walletLingnanCardsAvailabledCitys;


                                                                 if (recommendedCity) {
                                                                     NSLog(@" CityID: %@", recommendedCity.api_walletLingnanCardCityID);
                                                                     NSLog(@" CityName: %@", recommendedCity.api_walletLingnanCardCityName);
                                                                     NSLog(@" AID: %@", recommendedCity.api_walletLingnanCardAID);
                                                                     NSLog(@" Name: %@", recommendedCity.api_walletLingnanCardName);
                                                                     NSLog(@" HasSubCity: %d", recommendedCity.api_walletLingnanCardHasSubCity);
                                                                     NSLog(@" OpenedImgUrl: %@", recommendedCity.api_walletLingnanCardOpenedImgUrl);
                                                                     NSLog(@" ParentAppCode: %@", recommendedCity.api_walletLingnanCardParentAppCode);
                                                                     NSLog(@" ServiceScope: %@", recommendedCity.api_walletLingnanCardServiceScope);
                                                                     NSLog(@" Status: %zd", recommendedCity.api_walletLingnanCardStatus);
                                                                     NSLog(@" SupportApps: %@", recommendedCity.api_walletLingnanCardSupportApps);
                                                                     NSLog(@" UnopenedImgUrl: %@", recommendedCity.api_walletLingnanCardUnopenedImgUrl);
                                                                     NSLog(@" VisibleGroups: %@", recommendedCity.api_walletLingnanCardVisibleGroups);
                                                                     NSLog(@" XiaomiCardName: %@", recommendedCity.api_walletLingnanCardXiaomiCardName);
                                                                     NSLog(@"");
                                                                 }

                                                                 for (id<HMServiceAPIWalletLingnanCardCityProtocol> city in availableCitys) {
                                                                     NSLog(@" CityID: %@", city.api_walletLingnanCardCityID);
                                                                     NSLog(@" CityName: %@", city.api_walletLingnanCardCityName);
                                                                     NSLog(@" AID: %@", city.api_walletLingnanCardAID);
                                                                     NSLog(@" Name: %@", city.api_walletLingnanCardName);
                                                                     NSLog(@" HasSubCity: %d", city.api_walletLingnanCardHasSubCity);
                                                                     NSLog(@" OpenedImgUrl: %@", city.api_walletLingnanCardOpenedImgUrl);
                                                                     NSLog(@" ParentAppCode: %@", city.api_walletLingnanCardParentAppCode);
                                                                     NSLog(@" ServiceScope: %@", city.api_walletLingnanCardServiceScope);
                                                                     NSLog(@" Status: %zd", city.api_walletLingnanCardStatus);
                                                                     NSLog(@" SupportApps: %@", city.api_walletLingnanCardSupportApps);
                                                                     NSLog(@" UnopenedImgUrl: %@", city.api_walletLingnanCardUnopenedImgUrl);
                                                                     NSLog(@" VisibleGroups: %@", city.api_walletLingnanCardVisibleGroups);
                                                                     NSLog(@" XiaomiCardName: %@", city.api_walletLingnanCardXiaomiCardName);
                                                                     NSLog(@"");
                                                                 }

                                                                 [expectation fulfill];
                                                             }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}



- (void)testInstalledCards {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"testInstalledCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_installedCardsWithCompletionBlock:^(NSString *status, NSString *message, NSArray<NSString *> *applicationIDs) {

        for (NSString *applicationID in applicationIDs) {
            NSLog(@"applicationID  %@", applicationID);
        }

        [expectation fulfill];
    }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCardID {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testInstalledCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_cardIDWithCityID:@"9005"
                                                             aid:@"222"
                                                      cardNumber:@"222"
                                                 completionBlock:^(NSString *status, NSString *message, NSString *cardID) {

                                                     if (cardID.length > 0) {

                                                         NSLog(@"cardID  %@", cardID);
                                                     }

                                                     [expectation fulfill];

                                                 }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testProtocol {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testProtocol"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_protocolWithXiaomiCardName:@"ZHENGZHOU"
                                                               acctionType:@"RECHARGE"
                                                           completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletProtocol> protocol) {

                                                               if (protocol) {
                                                                   NSLog(@" ID: %@", protocol.api_walletProtocolID);
                                                                   NSLog(@" Title: %@", protocol.api_walletProtocolTitle);
                                                                   NSLog(@" Content: %@", protocol.api_walletProtocolContent);
                                                                   NSLog(@" ServiceName: %@", protocol.api_walletProtocolServiceName);
                                                                   NSLog(@" Update: %d", protocol.api_walletProtocolUpdate);
                                                                   NSLog(@" NeedConfirm: %d", protocol.api_walletProtocolNeedConfirm);
                                                                   NSLog(@"");
                                                               }

                                                               [expectation fulfill];
                                                           }];
//    RECHARGE
//    ISSUE
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testConfirmProtocol {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testConfirmProtocol"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_confirmProtocolWithID:@"23"
                                                      completionBlock:^(NSString *status, NSString *message) {

                                                          [expectation fulfill];
                                                      }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCacessCard {


    id<HMServiceAPIWalletaAcessCardProtocol> mock = OCMProtocolMock(@protocol(HMServiceAPIWalletaAcessCardProtocol));

    
    OCMStub([mock api_walletAcessCardAtqa]).andReturn(@"0400");
    OCMStub([mock api_walletAcessCardBlockContent]).andReturn(@"1111111111");
    OCMStub([mock api_walletAcessCardSak]).andReturn(@"08");
    OCMStub([mock api_walletAcessCardUid]).andReturn(@"ce9c6d54");
    OCMStub([mock api_walletAcessCardSize]).andReturn(10);
    OCMStub([mock api_walletAcessCardFareCardType]).andReturn(0);
    OCMStub([mock api_walletOrderRequestAPDUType]).andReturn(HMServiceWalletInstructionTypeCopyFareCard);

    OCMStub([mock api_walletOrderRequestAPDUAid]).andReturn(@"");
    OCMStub([mock api_walletOrderRequestAPDUFetchMode]).andReturn(@"SYNC");

    XCTestExpectation *expectation = [self expectationWithDescription:@"testConfirmProtocol"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_cacessCard:mock
                                           completionBlock:^(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>result) {

                                               NSLog(@"api_walletOrderAPDUSession %@", result.api_walletOrderAPDUSession);
                                               NSLog(@"api_walletOrderAPDUSession %@", result.api_walletOrderAPDUNextStep);

                                               for (id<HMServiceAPIWalletOrderAPDUCommandProtocol> command in result.api_walletOrderAPDUCommands) {
                                                   NSLog(@"api_walletOrderAPDUIndex %@", command.api_walletOrderAPDUIndex);
                                                   NSLog(@"api_walletOrderAPDUCommand %@", command.api_walletOrderAPDUCommand);
                                                   NSLog(@"api_walletOrderAPDUCheckCode %@", command.api_walletOrderAPDUCheckCode);
                                                   NSLog(@"api_walletOrderAPDUResult %@", command.api_walletOrderAPDUResult);
                                                   
                                               }

                                               [expectation fulfill];
                                           }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testAcessCards {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testAcessCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_acessCardWithCompletionBlock:^(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos) {


        for (id<HMServiceAPIWalletaAcessCardInfoProtocol>info in infos) {
            NSLog(@"api_walletAcessCardInfoAid %@", info.api_walletAcessCardInfoAid);
            NSLog(@"api_walletAcessCardInfoCardArt %@", info.api_walletAcessCardInfoCardArt);
            NSLog(@"api_walletAcessCardInfoCardType %zd", info.api_walletAcessCardInfoCardType);
            NSLog(@"api_walletAcessCardInfoFingerFlag %zd", info.api_walletAcessCardInfoFingerFlag);
            NSLog(@"api_walletAcessCardInfoName %@", info.api_walletAcessCardInfoName);
            NSLog(@"api_walletAcessCardInfoUserTerms %@", info.api_walletAcessCardInfoUserTerms);
            NSLog(@"api_walletAcessCardInfoVSStatus %zd", info.api_walletAcessCardInfoVSStatus);
            NSLog(@"api_walletAcessCardInfoAid %@", info.api_walletAcessCardInfoAid);
        }
        [expectation fulfill];
    }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testAcessCard {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testAcessCard"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_acessCardWithSessionID:@"220-1696298710-04779921809"
                                                       completionBlock:^(NSString *status, NSString *message,  NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos) {

                                                           for (id<HMServiceAPIWalletaAcessCardInfoProtocol>info in infos) {
                                                               NSLog(@"api_walletAcessCardInfoAid %@", info.api_walletAcessCardInfoAid);
                                                               NSLog(@"api_walletAcessCardInfoCardArt %@", info.api_walletAcessCardInfoCardArt);
                                                               NSLog(@"api_walletAcessCardInfoCardType %zd", info.api_walletAcessCardInfoCardType);
                                                               NSLog(@"api_walletAcessCardInfoFingerFlag %zd", info.api_walletAcessCardInfoFingerFlag);
                                                               NSLog(@"api_walletAcessCardInfoName %@", info.api_walletAcessCardInfoName);
                                                               NSLog(@"api_walletAcessCardInfoUserTerms %@", info.api_walletAcessCardInfoUserTerms);
                                                               NSLog(@"api_walletAcessCardInfoVSStatus %zd", info.api_walletAcessCardInfoVSStatus);
                                                               NSLog(@"api_walletAcessCardInfoAid %@", info.api_walletAcessCardInfoAid);
                                                           }

                                                           [expectation fulfill];
                                                       }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUpdateAcessCards {

    id<HMServiceAPIWalletaAcessCardInfoProtocol> mock = OCMProtocolMock(@protocol(HMServiceAPIWalletaAcessCardInfoProtocol));
    OCMStub([mock api_walletAcessCardInfoAid]).andReturn(@"A0000003964D344D10046A18B3354A04");
    OCMStub([mock api_walletAcessCardInfoCardArt]).andReturn(@"");
    OCMStub([mock api_walletAcessCardInfoCardType]).andReturn(0);
    OCMStub([mock api_walletAcessCardInfoFingerFlag]).andReturn(0);
    OCMStub([mock api_walletAcessCardInfoName]).andReturn(@"家");
    OCMStub([mock api_walletAcessCardInfoUserTerms]).andReturn(@"");
    OCMStub([mock api_walletAcessCardInfoVSStatus]).andReturn(0);

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateAcessCards"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI wallet_updateAcessCard:mock
                                                completionBlock:^(NSString *status, NSString *message) {

                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


@end
