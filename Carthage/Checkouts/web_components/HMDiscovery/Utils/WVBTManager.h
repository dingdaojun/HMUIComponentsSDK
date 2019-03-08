//  WVBTManager.h
//  Created on 2018/5/16
//  Description webView Bracelet Manager.

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import "WVJBCommon.h"

@protocol WVBTManagerDelegate <NSObject>

@optional
- (void)braceletManagerDict:(NSDictionary *)braceletDict
               braceletType:(HMHtmlBraceletType)braceletType;

@end

typedef void(^HMHtmlBraceletManagerBlock)(NSDictionary *braceletDict, HMHtmlBraceletType braceletType);

@interface WVBTManager : NSObject

@property (nonatomic, weak) id<WVBTManagerDelegate> delegate;

- (void)setHtmlBraceletTypeWithRequestString:(NSString *)requestString;

@end
