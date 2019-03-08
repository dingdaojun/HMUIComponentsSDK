//  HMWeatherAlertItem.m
//  Created on 2018/1/4
//  Description 天气预警

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherAlertItem.h"
@import HMCategory.NSDate_HMStringFormat;

@implementation HMWeatherAlertItem

- (instancetype)initWithWarningData:(id<HMServiceAPIWeatherWarningData>)weatherWarningData locationKey:(NSString *)locationKey {
    self = [super init];
    if (self) {
        self.alertId = weatherWarningData.api_weatherWarningDataAlertID;
        self.title = weatherWarningData.api_weatherWarningDataTitle;
        self.detail = weatherWarningData.api_weatherWarningDataDetail;
        self.type = weatherWarningData.api_weatherWarningDataType;
        self.level = weatherWarningData.api_weatherWarningDataLevel;
        self.images = weatherWarningData.api_weatherWarningDataImages;
        self.pubTime = [weatherWarningData.api_weatherWarningDataPubTime stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
        self.lastUpdateDate = [NSDate date];
        self.locationKey = locationKey;
    }
    return self;
}

- (instancetype)initWithDBWarningData:(id<HMDBWeatherEarlyWarningProtocol>)dbWarningData {
    self = [super init];
    if (self) {
        self.pubTime = dbWarningData.dbEarlyWarningPublishTime;
        self.alertId = dbWarningData.dbWarningID;
        self.title = dbWarningData.dbTitle;
        self.detail = dbWarningData.dbDetail;
        self.lastUpdateDate = dbWarningData.dbRecordUpdateTime;
        self.locationKey = dbWarningData.dbLocationKey;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pubTime:%@ \n alertId:%@ \n title:%@ \n detail:%@ ",self.pubTime,self.alertId,self.title,self.detail];
}

#pragma mark - db fields
// 天气预警数据发布时间
- (NSString *)dbEarlyWarningPublishTime {
    return self.pubTime;
}
// 预警 ID
- (NSString *)dbWarningID {
    return self.alertId;
}
// 预警标题
- (NSString *)dbTitle {
    return self.title;
}
// 预警详情
- (NSString *)dbDetail {
    return self.detail;
}
// 数据库记录更新时间
- (NSDate *)dbRecordUpdateTime {
    return self.lastUpdateDate;
}
// 行政区key
- (NSString *)dbLocationKey {
    return self.locationKey;
}
#pragma mark - 返回的数据结构
/*{
    alerts = (
              {
                  detail = 朝阳区气象台09日16时45分继续发布大风蓝色预警,受补充冷空气影响，预计10日朝阳区仍有4、5级偏北风，阵风7级左右，请注意防范。;
                  images = {
                      icon = http:f5.market.xiaomi.com/download/MiSafe/0f9daf5ba050f4eda2eea7bbebb22d33bbefa7e48/a.webp;
                      notice = http:f5.market.xiaomi.com/download/MiSafe/0698347331408e6b152610a85b32892b64f404343/a.webp;
                  }
                  ;
                  locationKey = weathercn:101010300;
                  alertId = weathercn:101010300-1515487500000-大风蓝色;
                  level = 蓝色;
                  title = 朝阳区大风蓝色预警;
                  pubTime = 2018-01-09T16:45:00+08:00;
                  type = 大风;
              }
              ,
              );
}*/
@end
