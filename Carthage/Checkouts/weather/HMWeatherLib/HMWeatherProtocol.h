//  HMWeatherProtocol.h
//  Created on 2018/5/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

@protocol HMWeatherProtocol <NSObject>

@end

@protocol HMWeatherSunRiseSetItemProtocol <NSObject>
/** 日出时间 */
@property (readonly) NSDate      *sunriseDate;
/** 日落时间 */
@property (readonly) NSDate      *sunsetDate;

@end


