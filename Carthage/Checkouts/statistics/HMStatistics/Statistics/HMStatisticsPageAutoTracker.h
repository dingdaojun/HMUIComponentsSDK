//  HMStatisticsPageAutoTracker.h
//  Created on 2018/6/29
//  Description 无埋点时长统计用于替换 Class Name 的协议

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <Foundation/Foundation.h>

@protocol HMStatisticsPageAutoTracker <NSObject>

@required
/**
 获取页面名称用于替换默认埋点中的 Class Name

 @return 产品定义页面名
 */
- (NSString *)hmStatisticsAutoTrackerPageName;

@end
