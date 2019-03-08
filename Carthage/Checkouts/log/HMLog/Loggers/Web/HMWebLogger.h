//
//  HMWebLogger.h
//  HMLog
//
//  Created by 李宪 on 13/1/2017.
//  Copyright © 2017 李宪. All rights reserved.
//

#import "GCDWebServer.h"

#import "HMLogger.h"

@interface HMWebLogger : GCDWebServer <HMLogger>

- (instancetype)initWithPort:(NSUInteger)port;

@end
