//  ViewController.m
//  Created on 2018/3/28
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "ViewController.h"
#import "HMWeatherInfo.h"
@import HMCategory;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    "longitude" : "116.829",
    //    "latitude" : "31.292",
    NSLog(@"home dir : %@",NSHomeDirectory());
    NSLog(@"时间戳 -- %lld",[NSDate date].milliSecondsSince1970);
    
    //[self timestampSwitchTime:1527761357775];
    //[self timestampSwitchTime:1527761436081];
    
    // 1527823087
    NSDate *prevDate = [NSDate dateWithTimeIntervalSince1970:1527823087];
    NSLog(@"preDate -- %@ , curDate -- %@",prevDate,[NSDate date]);
    NSInteger seconds = [prevDate secondsBeforeDate:[NSDate date]];
    NSLog(@"相差 %ld 秒",(long)seconds);
}

- (NSInteger)getNowTimestamp {
    NSDate *datenow = [NSDate date];
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp);
    return timeSp;
}

- (NSString *)timestampSwitchTime:(long long)timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSTimeInterval tmpTimeStamp = (NSTimeInterval)(timestamp / 1000);
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tmpTimeStamp];
    NSLog(@"timestamp: %lld  == %@",timestamp, confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

- (IBAction)tryIt:(id)sender {
    // 定位获取
    CLLocation *location = [[CLLocation alloc] initWithLatitude:31.292 longitude:116.829];
    //[self refresWeather:location];
    
    // 测试定位获取日出日落
    [self testCurLocationSunRiseWithLocation:location];
    
    // locationKey获取天气数据
    //深圳  weathercn:101280601
    //香港  accu:1123655
    //[self refreshWeatherWithLocationKey:@"weathercn:101280601"];
}

- (void)refresWeather:(CLLocation *)location {
    HMWeatherInfo *weatherInfo = [HMWeatherInfo shareInfo];
    
    [weatherInfo requestWeatherInfoWithLocationCoordinate:location.coordinate isGlobal:NO Completion:^(NSString *locationKey, BOOL hasRequestSuccess, BOOL hasWeatherUpdate) {

        NSLog(@"locationKey : %@ -- hasRequestSuccess : %d -- hasWeatherUpdate : %d",locationKey,hasRequestSuccess,hasWeatherUpdate);
        
        HMWeatherAirQualityItem *curAQI = [weatherInfo currentAQIForDevice:YES];
        HMWeatherCurrentItem *curWeather = [weatherInfo currentRealDataForDevice:YES];
        NSLog(@"curAQI: %@ -- curWeather: %@",curAQI, curWeather);
        
        
        // 当日的日出日落数据
        id<HMWeatherSunRiseSetItemProtocol> sunRiseSet = [weatherInfo curSunRiseSetWithAutoLocate:YES];
        NSLog(@"sunRise -- %@, sunSet -- %@",sunRiseSet.sunriseDate, sunRiseSet.sunsetDate);
        NSLog(@"class -- %@",[sunRiseSet.sunsetDate class]);
    }];
}

- (void)refreshWeatherWithLocationKey:(NSString *)locationKey {
    
    //深圳  weathercn:101280601
    //香港  accu:1123655
    HMWeatherInfo *weatherInfo = [HMWeatherInfo shareInfo];
    
    [weatherInfo requestWeatherInfoWithLocationKey:locationKey isGlobal:YES Completion:^(NSString * _Nonnull locationKey, BOOL hasRequestSuccess, BOOL hasWeatherUpdate) {
        NSLog(@"locationKey : %@ -- hasRequestSuccess : %d -- hasWeatherUpdate : %d",locationKey,hasRequestSuccess,hasWeatherUpdate);
        
        HMWeatherAirQualityItem *curAQI = [weatherInfo currentAQIForDevice:YES];
        HMWeatherCurrentItem *curWeather = [weatherInfo currentRealDataForDevice:YES];
        NSLog(@"curAQI: %@ -- curWeather: %@",curAQI, curWeather);
    }];
}

- (void)testCurLocationSunRiseWithLocation:(CLLocation *)location {
    HMWeatherInfo *weatherInfo = [HMWeatherInfo shareInfo];
    
    [weatherInfo fetchSunRiseWithCoordination:location.coordinate isGlobal:NO completion:^(BOOL isSuccess, BOOL isUpdate) {
        NSLog(@"success -- %d, update -- %d",isSuccess,isUpdate);
        
        // 当日的日出日落数据
        id<HMWeatherSunRiseSetItemProtocol> sunRiseSet = [weatherInfo curSunRiseSetWithAutoLocate:NO];
        NSLog(@"sunRise -- %@, sunSet -- %@",sunRiseSet.sunriseDate, sunRiseSet.sunsetDate);
        NSLog(@"class -- %@",[sunRiseSet.sunsetDate class]);
    }];
}
@end
