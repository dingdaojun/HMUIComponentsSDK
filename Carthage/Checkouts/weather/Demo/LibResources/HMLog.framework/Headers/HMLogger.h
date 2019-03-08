//
//  HMLogger.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMLogItem;


@protocol HMLogger <NSObject>

@required
- (void)recordLogItem:(HMLogItem *)item;

@end
