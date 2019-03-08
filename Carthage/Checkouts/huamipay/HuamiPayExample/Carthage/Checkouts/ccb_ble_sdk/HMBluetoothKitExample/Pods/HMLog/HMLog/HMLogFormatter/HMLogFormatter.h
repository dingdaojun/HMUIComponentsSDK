//
//  HMLogFormatter.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMLogItem;
@class HMLogConfiguration;

@protocol HMLogFormatter <NSObject>

- (NSString *)formattedTextWithItem:(HMLogItem *)item;

@end


@interface HMLogFormatter : NSObject <HMLogFormatter>

@property (nonatomic, strong) HMLogConfiguration *configuration;

+ (instancetype)formatterWithConfiguration:(HMLogConfiguration *)configuration;

@end
