//
//  AmazfitServiceTest.m
//  HMNetworkLayerDemoTests
//
//  Created by 朱立挺 on 2018/4/2.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import "HMServiceTest.h"
#import <AmazfitWatchService/AmazfitWatchService.h>

@interface AmazfitServiceTest : HMServiceTest

@end

@implementation AmazfitServiceTest

- (void)testConfig {
    
    [[[HMServiceAPI defaultService]
      configuration_retrieveWithCompletionBlock:^(BOOL success, NSString *message, id<HMServiceAPIConfiguration>serviceAPIConfiguraiton) {
          
   
      }] printCURL];
    
}

@end
