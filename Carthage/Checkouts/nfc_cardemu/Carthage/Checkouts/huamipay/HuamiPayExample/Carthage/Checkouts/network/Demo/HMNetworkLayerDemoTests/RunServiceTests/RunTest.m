//  RunTest.m
//  Created on 2018/3/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import RunService;
@import OCMock;


@interface RunTest : HMServiceTest

@end

@implementation RunTest

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


- (void)testRunUploadSummary {

//    id<HMServiceAPIRunSummaryData> mock = OCMProtocolMock(@protocol(HMServiceAPIRunSummaryData));
//    OCMStub([mock api_runSummaryDataParentTrackID]).andReturn(@"1511110531");
//    OCMStub([mock api_runSummaryDataChildList]).andReturn(@[]);
//    OCMStub([mock api_runSummaryDataType]).andReturn(HMServiceAPIRunTypeOutdoor);
//    OCMStub([mock api_runSummaryDataDistance]).andReturn(5017.000000);
//    OCMStub([mock api_runSummaryDataCalorie]).andReturn(302.000000);
//    OCMStub([mock api_runSummaryDataEndTime]).andReturn([NSDate date]);
//    OCMStub([mock api_runSummaryDataRunTime]).andReturn(2360.000000);
//    OCMStub([mock api_runSummaryDataAvgPace]).andReturn(0.470401);
//    OCMStub([mock api_runSummaryDataAvgFrequency]).andReturn(162);
//    OCMStub([mock api_runSummaryDataAvgHeareRate]).andReturn(163);
//    OCMStub([mock api_runSummaryDataForefootRatio]).andReturn(0);
//    OCMStub([mock api_runSummaryDataMaxPace]).andReturn(1.716283);
//    OCMStub([mock api_runSummaryDataMinPace]).andReturn(0.371123);
//    OCMStub([mock api_runSummaryDataAltitudeAscend]).andReturn(12.000000);
//    OCMStub([mock api_runSummaryDataAltitudeDescend]).andReturn(21.000000);
//    OCMStub([mock api_runSummaryDataStepLength]).andReturn(78.000000);
//    OCMStub([mock api_runSummaryDataTotalStep]).andReturn(6362);
//    OCMStub([mock api_runSummaryDataClimbAscendDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbDescendDis]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbAscendTime]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbDescendTime]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxCadence]).andReturn(185);
//    OCMStub([mock api_runSummaryDataAvgCadence]).andReturn(162);
//    OCMStub([mock api_runSummaryDataBindDevice]).andReturn(@"0:MILI:8");
//    OCMStub([mock api_runSummaryDataLocation]).andReturn(@"wtem1kkzuwj8");
//    OCMStub([mock api_runSummaryDataCity]).andReturn(@"");
//    OCMStub([mock api_runSummaryDataFlightRatio]).andReturn(0.000000);
//    OCMStub([mock api_runSummaryDataLandingTime]).andReturn(0.000000);
//    OCMStub([mock api_runSummaryDataMaxAltitude]).andReturn(-20000.000000);
//    OCMStub([mock api_runSummaryDataMinAltitude]).andReturn(-20000.000000);
//    OCMStub([mock api_runSummaryDataLapDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxHeartRate]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataMinHeartRate]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeEfficiency]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeTime]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeTrips]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataAverageStrokeSpeed]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxStrokeSpeed]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataStrokeDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataSwimPoolLength]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataSwimStyleType]).andReturn(HMServiceAPIRunSwimStyleTypeDefault);
//    OCMStub([mock api_runSummaryDataTrainEffect]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataMaxstepFrequency]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataUnit]).andReturn(HMServiceAPIRunMetricUnit);
//
//    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
//                              run_uploadSummaryData:mock
//                              completionBlock:^(BOOL success, NSString *message) {
//
//                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
//                                                         parameters:nil
//                                                            success:success
//                                                            message:message
//                                                               data:nil];
//                              }];
//    [api printCURL];
}

- (void)testRunDeleteSummary {

//    id<HMServiceAPIRunSummaryData> mock = OCMProtocolMock(@protocol(HMServiceAPIRunSummaryData));
//    OCMStub([mock api_runSummaryDataParentTrackID]).andReturn(@"1511110531");
//    OCMStub([mock api_runSummaryDataChildList]).andReturn(@[]);
//    OCMStub([mock api_runSummaryDataType]).andReturn(HMServiceAPIRunTypeOutdoor);
//    OCMStub([mock api_runSummaryDataDistance]).andReturn(5017.000000);
//    OCMStub([mock api_runSummaryDataCalorie]).andReturn(302.000000);
//    OCMStub([mock api_runSummaryDataEndTime]).andReturn([NSDate date]);
//    OCMStub([mock api_runSummaryDataRunTime]).andReturn(2360.000000);
//    OCMStub([mock api_runSummaryDataAvgPace]).andReturn(0.470401);
//    OCMStub([mock api_runSummaryDataAvgFrequency]).andReturn(162);
//    OCMStub([mock api_runSummaryDataAvgHeareRate]).andReturn(163);
//    OCMStub([mock api_runSummaryDataForefootRatio]).andReturn(0);
//    OCMStub([mock api_runSummaryDataMaxPace]).andReturn(1.716283);
//    OCMStub([mock api_runSummaryDataMinPace]).andReturn(0.371123);
//    OCMStub([mock api_runSummaryDataAltitudeAscend]).andReturn(12.000000);
//    OCMStub([mock api_runSummaryDataAltitudeDescend]).andReturn(21.000000);
//    OCMStub([mock api_runSummaryDataStepLength]).andReturn(78.000000);
//    OCMStub([mock api_runSummaryDataTotalStep]).andReturn(6362);
//    OCMStub([mock api_runSummaryDataClimbAscendDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbDescendDis]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbAscendTime]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataClimbDescendTime]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxCadence]).andReturn(185);
//    OCMStub([mock api_runSummaryDataAvgCadence]).andReturn(162);
//    OCMStub([mock api_runSummaryDataBindDevice]).andReturn(@"0:MILI:8");
//    OCMStub([mock api_runSummaryDataLocation]).andReturn(@"wtem1kkzuwj8");
//    OCMStub([mock api_runSummaryDataCity]).andReturn(@"");
//    OCMStub([mock api_runSummaryDataFlightRatio]).andReturn(0.000000);
//    OCMStub([mock api_runSummaryDataLandingTime]).andReturn(0.000000);
//    OCMStub([mock api_runSummaryDataMaxAltitude]).andReturn(-20000.000000);
//    OCMStub([mock api_runSummaryDataMinAltitude]).andReturn(-20000.000000);
//    OCMStub([mock api_runSummaryDataLapDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxHeartRate]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataMinHeartRate]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeEfficiency]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeTime]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataStrokeTrips]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataAverageStrokeSpeed]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataMaxStrokeSpeed]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataStrokeDistance]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataSwimPoolLength]).andReturn(-1.000000);
//    OCMStub([mock api_runSummaryDataSwimStyleType]).andReturn(HMServiceAPIRunSwimStyleTypeDefault);
//    OCMStub([mock api_runSummaryDataTrainEffect]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataMaxstepFrequency]).andReturn(-1);
//    OCMStub([mock api_runSummaryDataUnit]).andReturn(HMServiceAPIRunMetricUnit);
//
//    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
//                              run_deleteSummaryData:mock
//                              completionBlock:^(BOOL success, NSString *message) {
//
//                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
//                                                         parameters:nil
//                                                            success:success
//                                                            message:message
//                                                               data:nil];
//                              }];
//    [api printCURL];
}

- (void)testRunHistory {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testRunHistory"];
    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              run_historyWithSource:HMServiceAPIRunSourceTypeMifit
                              runTypes:@[@(HMServiceAPIRunTypeAll)]
                              friendID:@""
                              startTime:[NSDate date]
                              count:20
                              submotion:YES
                              completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunSummaryData>> *runSummarys) {

                                  for (id<HMServiceAPIRunSummaryData> runSummary in runSummarys) {

                                      NSLog(@"id is: %@", runSummary.api_runDataTrackID);
                                      NSLog(@"date is: %@", [NSDate dateWithTimeIntervalSince1970:[runSummary.api_runDataTrackID integerValue]]);
                                      NSLog(@"version is: %d", (int)runSummary.api_runDataVersion);
                                      NSLog(@"type is: %d", (int)runSummary.api_runSummaryDataType);

                                      NSLog(@"ParentTrackID is: %@", runSummary.api_runSummaryDataParentTrackID);
                                      NSLog(@"ChildList is: %@", runSummary.api_runSummaryDataChildList);

                                      NSLog(@"distance is: %lf", runSummary.api_runSummaryDataDistance);

                                      NSLog(@"Calorie is: %lf", runSummary.api_runSummaryDataCalorie);
                                      NSLog(@"EndTime is: %@", runSummary.api_runSummaryDataEndTime);
                                      NSLog(@"RunTime is: %lf", runSummary.api_runSummaryDataRunTime);
                                      NSLog(@"AvgPace is: %lf", runSummary.api_runSummaryDataAvgPace);
                                      NSLog(@"AvgFrequency is: %d", (int)runSummary.api_runSummaryDataAvgFrequency);
                                      NSLog(@"AvgHeareRate is: %d", (int)runSummary.api_runSummaryDataAvgHeareRate);
                                      NSLog(@"ForefootRatio is: %d", (int)runSummary.api_runSummaryDataForefootRatio);

                                      NSLog(@"MaxPace is: %lf", runSummary.api_runSummaryDataMaxPace);
                                      NSLog(@"MinPace is: %lf", runSummary.api_runSummaryDataMinPace);
                                      NSLog(@"AltitudeAscend is: %lf", runSummary.api_runSummaryDataAltitudeAscend);
                                      NSLog(@"AltitudeDescend is: %lf", runSummary.api_runSummaryDataAltitudeDescend);
                                      NSLog(@"StepLength is: %lf", runSummary.api_runSummaryDataStepLength);
                                      NSLog(@"TotalStep is: %d", (int)runSummary.api_runSummaryDataTotalStep);

                                      NSLog(@"ClimbAscendDistance is: %lf", runSummary.api_runSummaryDataClimbAscendDistance);
                                      NSLog(@"ClimbDescendDis is: %lf", runSummary.api_runSummaryDataClimbDescendDis);
                                      NSLog(@"ClimbAscendTime is: %lf", runSummary.api_runSummaryDataClimbAscendTime);
                                      NSLog(@"ClimbDescendTime is: %lf", runSummary.api_runSummaryDataClimbDescendTime);
                                      NSLog(@"MaxCadence is: %d", (int)runSummary.api_runSummaryDataMaxCadence);
                                      NSLog(@"AvgCadence is: %d", (int)runSummary.api_runSummaryDataAvgCadence);

                                      NSLog(@"BindDevice is: %@", runSummary.api_runSummaryDataBindDevice);
                                      NSLog(@"Location is: %@", runSummary.api_runSummaryDataLocation);
                                      NSLog(@"City is: %@", runSummary.api_runSummaryDataCity);

                                      NSLog(@"FlightRatio is: %lf", runSummary.api_runSummaryDataFlightRatio);
                                      NSLog(@"LandingTime is: %lf", runSummary.api_runSummaryDataLandingTime);

                                      NSLog(@"MaxAltitude is: %lf", runSummary.api_runSummaryDataMaxAltitude);
                                      NSLog(@"MinAltitude is: %lf", runSummary.api_runSummaryDataMinAltitude);
                                      NSLog(@"LapDistance is: %lf", runSummary.api_runSummaryDataLapDistance);
                                      NSLog(@"MaxHeartRate is: %ld", runSummary.api_runSummaryDataMaxHeartRate);
                                      NSLog(@"MinHeartRate is: %ld", runSummary.api_runSummaryDataMinHeartRate);
                                      NSLog(@"StrokeEfficiency is: %ld", runSummary.api_runSummaryDataStrokeEfficiency);
                                      NSLog(@"StrokeTime is: %ld", runSummary.api_runSummaryDataStrokeTime);
                                      NSLog(@"StrokeTrips is: %ld", runSummary.api_runSummaryDataStrokeTrips);
                                      NSLog(@"AverageStrokeSpeed is: %lf", runSummary.api_runSummaryDataAverageStrokeSpeed);
                                      NSLog(@"StrokeDistance is: %lf", runSummary.api_runSummaryDataMaxStrokeSpeed);
                                      NSLog(@"SwimPoolLength is: %lf", runSummary.api_runSummaryDataSwimPoolLength);
                                      NSLog(@"SwimStyleType is: %ld", runSummary.api_runSummaryDataSwimStyleType);
                                      NSLog(@"TrainEffect is: %ld", runSummary.api_runSummaryDataTrainEffect);
                                      NSLog(@"MaxstepFrequency is: %ld", runSummary.api_runSummaryDataMaxstepFrequency);

                                      NSLog(@"Unit is: %ld", runSummary.api_runSummaryDataUnit);
                                  }

                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testRunUpdateSummary {

    id<HMServiceAPIRunData> runData = OCMProtocolMock(@protocol(HMServiceAPIRunData));
    OCMStub([runData api_runDataSourceType]).andReturn(HMServiceAPIRunSourceTypeMifit);
    OCMStub([runData api_runDataTrackID]).andReturn(@"1530022546");
    OCMStub([runData api_runDataVersion]).andReturn(13);
    OCMStub([runData api_runStartTime]).andReturn([NSDate dateWithTimeIntervalSince1970:1530022546]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"testRunUpdateSummary"];
    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              run_updateSummaryWithType:HMServiceAPIRunSourceTypeMifit
                              trackID:@"1530022546"
                              distance:1001
                              completionBlock:^(BOOL success, NSString *message) {

                                  [expectation fulfill];
                              }];
    [api printCURL];

    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testRunUploadDetail {

//    NSTimeInterval startTime = 0;
//    XCTestExpectation *expectation = [self expectationWithDescription:@"testRunUploadDetail"];
//    id<HMServiceAPIRunDetailData> detailMock = OCMProtocolMock(@protocol(HMServiceAPIRunDetailData));
//    NSMutableArray *gpsMocks = [NSMutableArray array];
//    NSTimeInterval time = startTime;
//    for (NSInteger i = 0; i < 200; i++) {
//
//        id<HMServiceAPIRunGPSData> gpsMock = OCMProtocolMock(@protocol(HMServiceAPIRunGPSData));
//        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(20.0 + i, 30.0 + i);
//        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate2D
//                                                             altitude:60.5
//                                                   horizontalAccuracy:0
//                                                     verticalAccuracy:0
//                                                            timestamp:[NSDate dateWithTimeIntervalSince1970:time]];
//        OCMStub([gpsMock api_runGPSDataLoction]).andReturn(location);
//        [gpsMocks addObject:gpsMock];
//        time++;
//    }
//    OCMStub([detailMock api_runDetailDataGps]).andReturn(gpsMocks);
//
//    NSMutableArray *heartRateMocks = [NSMutableArray array];
//    time = startTime;
//    for (NSInteger i = 0; i < 200; i++) {
//
//        id<HMServiceAPIRunHeartRateData> heartRateMock = OCMProtocolMock(@protocol(HMServiceAPIRunHeartRateData));
//
//        NSInteger heartRate = arc4random_uniform(80) + 100;
//        NSDate *heartRateDate = [NSDate dateWithTimeIntervalSince1970:time];
//        OCMStub([heartRateMock api_runHeartRate]).andReturn(heartRate);
//        OCMStub([heartRateMock api_runHeartRateDate]).andReturn(heartRateDate);
//        [heartRateMocks addObject:heartRateMock];
//        time += arc4random_uniform(2) + 1;
//    }
//    OCMStub([detailMock api_runDetailDataHeartRate]).andReturn(heartRateMocks);
//
//    NSMutableArray *distanceMocks = [NSMutableArray array];
//    NSUInteger distance = 0;
//    time = startTime;
//    for (NSInteger i = 0; i < 200; i++) {
//
//        id<HMServiceAPIRunDistanceData> distanceMock = OCMProtocolMock(@protocol(HMServiceAPIRunDistanceData));
//
//        NSDate *distanceDate = [NSDate dateWithTimeIntervalSince1970:time];
//        OCMStub([distanceMock api_runDistance]).andReturn(distance);
//        OCMStub([distanceMock api_runDistanceDate]).andReturn(distanceDate);
//        [distanceMocks addObject:distanceMock];
//        time += arc4random_uniform(2) + 1;
//        distance += arc4random_uniform(2);
//    }
//    OCMStub([detailMock api_runDetailDataDistance]).andReturn(distanceMocks);
//
//    NSMutableArray *gaitMocks = [NSMutableArray array];
//    NSUInteger step = 0;
//    time = startTime;
//    for (NSInteger i = 0; i < 200; i++) {
//
//        id<HMServiceAPIRunGaitData> gaitMock = OCMProtocolMock(@protocol(HMServiceAPIRunGaitData));
//        NSDate *gaitDate = [NSDate dateWithTimeIntervalSince1970:time];
//        OCMStub([gaitMock api_runGaitStep]).andReturn(step);
//        OCMStub([gaitMock api_runGaitStepLength]).andReturn(0);
//        OCMStub([gaitMock api_runGaitStepCadence]).andReturn(0);
//        OCMStub([gaitMock api_runGaitDate]).andReturn(gaitDate);
//        [gaitMocks addObject:gaitMock];
//        time += arc4random_uniform(2) + 1;
//        step += arc4random_uniform(2);
//    }
//    OCMStub([detailMock api_runDetailDataGait]).andReturn(gaitMocks);
//    OCMStub([detailMock api_runDetailDataPressure]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataKiloPace]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataMilePace]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataLap]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataCorrectAltitude]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataStrokeSpeed]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataCadence]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataDailyPerformanceInfo]).andReturn(@[]);
//    OCMStub([detailMock api_runDetailDataSpeed]).andReturn(@[]);
//
//    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
//                              run_uploadDetailData:detailMock
//                              completionBlock:^(BOOL success, NSString *message) {
//
//                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
//                                                         parameters:nil
//                                                            success:success
//                                                            message:message
//                                                               data:nil];
//                                  [expectation fulfill];
//                              }];
//    [api printCURL];
//    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testRunDetail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRunDetail"];
    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              run_detailWithType:HMServiceAPIRunSourceTypeWatchEverest
                              trackid:1510793207
                              friendID:@""
                              completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIRunDetailData> runDetail) {

                                  if (!success) {
                                      [expectation fulfill];
                                      return;
                                  }

                                  NSLog(@"id is: %@", runDetail.api_runDataTrackID);
                                  NSLog(@"version is: %d", (int)runDetail.api_runDataVersion);

                                  for (id<HMServiceAPIRunPaceData> kiloPace in runDetail.api_runDetailDataKiloPace) {
                                      NSLog(@"kiloPace data");

                                      NSLog(@"Kilometer is: %d", (int)kiloPace.api_runPaceKilometer);
                                      NSLog(@"Time is: %lf", kiloPace.api_runPaceTime);
                                      NSLog(@"TotalTime is: %lf", kiloPace.api_runPaceTotalTime);
                                      NSLog(@"Location is: %lf,%lf", kiloPace.api_runPaceLocation.latitude, kiloPace.api_runPaceLocation.longitude);
                                      NSLog(@"HeartRate is: %d", (int)kiloPace.api_runPaceHeartRate);
                                  }

                                  for (id<HMServiceAPIRunPaceData> milepace in runDetail.api_runDetailDataMilePace) {
                                      NSLog(@"milepace data");

                                      NSLog(@"Kilometer is: %d", (int)milepace.api_runPaceKilometer);
                                      NSLog(@"Time is: %lf", milepace.api_runPaceTime);
                                      NSLog(@"TotalTime is: %lf", milepace.api_runPaceTotalTime);
                                      NSLog(@"Location is: %lf,%lf", milepace.api_runPaceLocation.latitude, milepace.api_runPaceLocation.longitude);
                                      NSLog(@"HeartRate is: %d", (int)milepace.api_runPaceHeartRate);
                                      NSLog(@"");
                                  }

                                  for (id<HMServiceAPIRunGPSData> gps in runDetail.api_runDetailDataGps) {
                                      NSLog(@"GPS data");

                                      NSLog(@"Loction is: %@", gps.api_runGPSDataLoction);
                                      NSLog(@"Time is: %lf", gps.api_runGPSRunTime);
                                      NSLog(@"Altitude is: %lf", gps.api_runGPSAltitude);
                                      NSLog(@"Pace is: %lf", gps.api_runGPSPace);
                                      NSLog(@"Flag is: %d", (int)gps.api_runGPSFlag);
                                  }

                                  NSLog(@"heartRate data");
                                  for (id<HMServiceAPIRunHeartRateData> heartRate in runDetail.api_runDetailDataHeartRate) {

                                      NSLog(@"date is: %@", heartRate.api_runHeartRateDate);
                                      NSLog(@"vale is: %d", (int)heartRate.api_runHeartRate);
                                  }

                                  NSLog(@"distance data");
                                  for (id<HMServiceAPIRunDistanceData> distance in runDetail.api_runDetailDataDistance) {

                                      NSLog(@"date is: %@", distance.api_runDistanceDate);
                                      NSLog(@"vale is: %d", (int)distance.api_runDistance);
                                  }

                                  NSLog(@"pressure data");
                                  for (id<HMServiceAPIRunPressureData> pressure in runDetail.api_runDetailDataPressure) {

                                      NSLog(@"date is: %@", pressure.api_runPressureDate);
                                      NSLog(@"vale is: %lf", pressure.api_runPressure);
                                  }

                                  NSLog(@"pause data");
                                  for (id<HMServiceAPIRunPauseData> pause in runDetail.api_runDetailDataPause) {
                                      NSLog(@"date is: %@", pause.api_runPauseDate);
                                      NSLog(@"Type is: %d", (int)pause.api_runPauseType);
                                      NSLog(@"Duration is: %lf", pause.api_runPauseDuration);
                                      NSLog(@"StartGpsIndex is: %d", (int)pause.api_runPauseStartGpsIndex);
                                      NSLog(@"EndGpsIndex is: %d", (int)pause.api_runPauseEndGpsIndex);
                                  }

                                  NSLog(@"gait data");
                                  for (id<HMServiceAPIRunGaitData> gait in runDetail.api_runDetailDataGait) {
                                      NSLog(@"date is: %@", gait.api_runGaitDate);
                                      NSLog(@"Step is: %d", (int)gait.api_runGaitStep);
                                      NSLog(@"StepLength is: %d", (int)gait.api_runGaitStepLength);
                                      NSLog(@"StepCadence is: %d", (int)gait.api_runGaitStepCadence);
                                  }

                                  NSLog(@"lap data");
                                  for (id<HMServiceAPIRunLapData> lap in runDetail.api_runDetailDataLap) {
                                      \
                                      NSLog(@"lapIndex is: %d", lap.api_runLapIndex);
                                      NSLog(@"time is: %@", lap.api_runLapDate);
                                      NSLog(@"distance is: %lf", lap.api_runLapDistance);
                                      NSLog(@"averageHeartRate is: %d", lap.api_runLapAverageHeartRate);
                                      NSLog(@"offsetTime is: %lf", lap.api_runLapRunTime);
                                      NSLog(@"altitude is: %lf", lap.api_runLapAltitude);
                                      NSLog(@"altitudeAscend is: %lf", lap.api_runLapAltitudeAscend);
                                      NSLog(@"altitudeDescend is: %lf", lap.api_runLapAltitudeDescend);
                                      NSLog(@"averagePace is: %lf", lap.api_runLapAveragePace);
                                      NSLog(@"maxPace is: %lf", lap.api_runLapMaxPace);
                                      NSLog(@"ascendDistance is: %lf", lap.api_runLapAscendDistance);
                                      NSLog(@"averageStrokeSpeed is: %ld", lap.api_runLapAverageStrokeSpeed);
                                      NSLog(@"strokeTime is: %ld", lap.api_runLapStrokeTime);
                                      NSLog(@"atrokeEfficiency is: %ld", lap.api_runLapStrokeEfficiency);
                                      NSLog(@"calorie is: %ld", lap.api_runLapCalorie);
                                      NSLog(@"averageFrequency is: %ld", lap.api_runLapAverageFrequency);
                                      NSLog(@"averageCadence is: %ld", lap.api_runLapAverageCadence);
                                      NSLog(@"type is: %ld", lap.api_runLapType);
                                  }

                                  NSLog(@"correctAltitude data");
                                  for (id<HMServiceAPIRunCorrectAltitudeData> correctAltitude in runDetail.api_runDetailDataCorrectAltitude) {

                                      NSLog(@"date is: %@", correctAltitude.api_runCorrectAltitudeDate);
                                      NSLog(@"vale is: %lf", correctAltitude.api_runCorrectAltitude);
                                  }

                                  NSLog(@"strokeSpeed data");
                                  for (id<HMServiceAPIRunStrokeSpeedData> strokeSpeed in runDetail.api_runDetailDataStrokeSpeed) {

                                      NSLog(@"date is: %@", strokeSpeed.api_runStrokeSpeedDate);
                                      NSLog(@"vale is: %lf", strokeSpeed.api_runStrokeSpeed);
                                  }

                                  NSLog(@"Cadence data");
                                  for (id<HMServiceAPIRunCadenceData> cadence in runDetail.api_runDetailDataCadence) {

                                      NSLog(@"date is: %@", cadence.api_runCadenceDate);
                                      NSLog(@"vale is: %lf", cadence.api_runCadence);
                                  }

                                  NSLog(@"dailyPerformanceInfo data");
                                  for (id<HMServiceAPIRunDailyPerformanceInfoData> dailyPerformanceInfo in runDetail.api_runDetailDataDailyPerformanceInfo) {

                                      NSLog(@"kilometer is: %.2f", dailyPerformanceInfo.api_runDailyPerformanceInfoKilometer);
                                      NSLog(@"vale is: %lf", dailyPerformanceInfo.api_runDailyPerformanceInfo);
                                  }

                                  NSLog(@"speed data");
                                  for (id<HMServiceAPIRunSpeedData> speedData in runDetail.api_runDetailDataSpeed) {

                                      NSLog(@"date is: %@", speedData.api_runSpeedDate);
                                      NSLog(@"vale is: %lf", speedData.api_runSpeed);
                                  }
                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testRunStat {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testRunStat"];
    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              run_statWithType:HMServiceAPIRunSourceTypeMifit
                              friendID:@""
                              completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunStatData>> *runStats) {

                                  for (id<HMServiceAPIRunStatData> runStat in runStats) {

                                      NSLog(@"RunTime %lf", runStat.api_runStatDataRunTime);
                                      NSLog(@"Calorie %lf", runStat.api_runStatDataCalorie);
                                      NSLog(@"Distance %d", (int)runStat.api_runStatDistance);
                                      NSLog(@"Count %d", (int)runStat.api_runStatCount);
                                      NSLog(@"RunType %d", (int)runStat.api_runStatRunType);
                                  }
                                  [expectation fulfill];
                              }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}





@end
