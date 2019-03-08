//
//  HMServiceAPI+AppItunesConnectService.m
//  AmazfitWatch
//
//  Created by 刘星 on 2017/12/12.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+ItunesConnect.h"
#import <HMNetworkLayer/HMNetworkLayer.h>
#import <HMService/HMService.h>


@implementation HMServiceAPI (ItunesConnect)

// @"http://itunes.apple.com/lookup?bundleId=%@&country=%@&lang=%@"
- (id<HMCancelableAPI>)itunesConnect_iconWithBundleID:(NSString *)bundleId completionBlock:(void (^)(BOOL, NSString *, NSArray<id<HMServiceAPIAppItunesConnectData>> *))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        NSString *url = @"http://itunes.apple.com/lookup";
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"bundleId"]     = bundleId;
//        parameters[@"country"]      = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
//        parameters[@"lang"]         = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        
        return [HMNetworkCore GET:url
                       parameters:parameters
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      if (error) {
                          !completionBlock ?: completionBlock(NO, error.localizedDescription, nil);
                          return;
                      }
            
                      NSDictionary *data = (NSDictionary *)responseObject;
                      NSArray *iconDatas = data.hmjson[@"results"].array;

                      if (completionBlock) {
                          completionBlock(YES, nil, iconDatas);
                      }
        }];
    }];
}

@end

@interface NSDictionary (HMServiceAPIAppItunesConnectData) <HMServiceAPIAppItunesConnectData>

@end

@implementation NSDictionary (HMServiceAPIAppItunesConnectData)

- (NSString *)api_appItunesConnectIcon {
    NSString *string = self.hmjson[@"artworkUrl100"].string;
    if (string.length == 0) {
        string = self.hmjson[@"artworkUrl60"].string;
    }
    if (string.length == 0) {
        string = self.hmjson[@"artworkUrl512"].string;
    }
    return string;
}

- (NSString *)api_appItunesConnectName {
    NSString *appTitle = self.hmjson[@"trackName"].string;
    NSRange  range0 = [appTitle rangeOfString:@"-"];
    if(range0.location != NSNotFound) {
        NSArray *titles = [appTitle componentsSeparatedByString:@"-"];
        if(titles.count > 0) {
            return titles[0];
        }
    } else {
        range0 = [appTitle rangeOfString:@"–"];
        if(range0.location != NSNotFound) {
            NSArray *titles = [appTitle componentsSeparatedByString:@"–"];
            if(titles.count > 0) {
                return titles[0];
            }
        } else {
            range0 = [appTitle rangeOfString:@"——"];
            if(range0.location != NSNotFound) {
                NSArray *titles = [appTitle componentsSeparatedByString:@"——"];
                if(titles.count > 0) {
                    return titles[0];;
                }
            } else {
                return appTitle;
            }
        }
    }
    return appTitle;
}

@end
