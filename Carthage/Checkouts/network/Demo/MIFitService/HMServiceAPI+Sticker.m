//
//  HMServiceAPI+Sticker.m
//  HMNetworkLayer
//
//  Created by 李宪 on 19/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Sticker.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (Sticker)

- (id<HMCancelableAPI>)sticker_cameraWatermarksWithLanguage:(NSString *)language
                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIStickerData>> *watermarks))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(language.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/apps/watermarks.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"lang" : language,
                                             @"category" : @"run"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSArray *data) {
                                          NSArray *stickers = nil;
                                          
                                          if (success) {
                                              stickers = [data sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                                                  NSUInteger sort1 = obj1.hmjson[@"sort"].unsignedIntegerValue;
                                                  NSUInteger sort2 = obj2.hmjson[@"sort"].unsignedIntegerValue;
                                                  return (sort1 > sort2 ? NSOrderedDescending : (sort1 < sort2 ? NSOrderedAscending : NSOrderedSame));
                                              }];
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, stickers);
                                          }
                                      }];
                  }];
    }];
}

- (id<HMCancelableAPI>)sticker_cameraStickersWithLanguage:(NSString *)language
                                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIStickerData>> *stickers))completionBlock {

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        !completionBlock ?: completionBlock(NO, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSParameterAssert(language.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"v1/apps/watermarks.json"];
        
        NSError *error = nil;
        NSDictionary *headers = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"userid" : userID,
                                             @"lang" : language,
                                             @"category" : @"stickers"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                      
                      [self legacy_handleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(BOOL success, NSString *message, NSArray *data) {
                                          NSArray *stickers = nil;
                                          
                                          if (success) {
                                              stickers = [data sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                                                  NSUInteger sort1 = obj1.hmjson[@"sort"].unsignedIntegerValue;
                                                  NSUInteger sort2 = obj2.hmjson[@"sort"].unsignedIntegerValue;
                                                  return (sort1 > sort2 ? NSOrderedDescending : (sort1 < sort2 ? NSOrderedAscending : NSOrderedSame));
                                              }];
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(success, message, stickers);
                                          }
                                      }];
                  }];
    }];
}

@end



@interface NSDictionary (HMServiceAPIStickerContent) <HMServiceAPIStickerContent>
@end

@implementation NSDictionary (HMServiceAPIStickerContent)

- (HMServiceAPIStickerContentType )api_stickerContentType {
    NSString *type = self.hmjson[@"type"].string;
    
    NSDictionary *map = @{@"mileage" : @(HMServiceAPIStickerContentTypeMileage),        // 里程
                          @"time" : @(HMServiceAPIStickerContentTypeTime),              // 用时
                          @"pace" : @(HMServiceAPIStickerContentTypePace),              // 配速
                          @"consume" : @(HMServiceAPIStickerContentTypeConsume),        // 消耗
                          @"heart_rate" : @(HMServiceAPIStickerContentTypeHeartRate),   // 心率
                          @"steps" : @(HMServiceAPIStickerContentTypeSteps),            // 步数
                          @"speed" : @(HMServiceAPIStickerContentTypeSpeed),            // 速度
                          @"cadence" : @(HMServiceAPIStickerContentTypeCadence),        // 步频
                          @"stride" : @(HMServiceAPIStickerContentTypeStride),          // 步幅
                          @"altitude" : @(HMServiceAPIStickerContentTypeAltitude),      // 海拔上升
                          @"forefoot" : @(HMServiceAPIStickerContentTypeForefoot)};     // 前脚掌着地
    
    return map.hmjson[type].unsignedIntegerValue;
}

- (CGFloat )api_stickerContentFontSize {
    return self.hmjson[@"font-size"].doubleValue;
}

- (HMServiceAPIStickerContentFontWeight )api_stickerContentFontWeight {
    NSString *weight = self.hmjson[@"font-weight"].string;
    if ([weight isEqualToString:@"bold"]) {
        return HMServiceAPIStickerContentFontWeightBold;
    }
    
    return HMServiceAPIStickerContentFontWeightLight;
}

- (HMServiceAPIStickerContentTextAlignment )api_stickerContentTextAlignment {
    return self.hmjson[@"left"][@"type"].unsignedIntegerValue;
}

- (UIColor *)api_stickerContentTextColor {
    return self.hmjson[@"color"].color ?: [UIColor whiteColor];
}

- (UIColor *)api_stickerContentTextBackgroundColor {
    return self.hmjson[@"anticolor"].color ?: [UIColor blackColor];
}

- (CGPoint )api_stickerContentTextPoint {
    CGFloat ratio = 1080.f / [UIScreen mainScreen].bounds.size.width;
    CGFloat left = self.hmjson[@"left"][@"text-align"].doubleValue / ratio;
    CGFloat top = self.hmjson[@"top"].doubleValue / ratio;
    return CGPointMake(left, top);
}

@end

@interface NSDictionary (HMServiceAPIStickerData) <HMServiceAPIStickerData>
@end

@implementation NSDictionary (HMServiceAPIStickerData)

- (BOOL)api_stickerValid {
    BOOL status = self.hmjson[@"status"].boolean;
    if (!status) {
        return NO;
    }
    
    NSDate *now = [NSDate date];
    NSDate *offlineTime = self.hmjson[@"offlineTime"].date;
    if ([now timeIntervalSinceDate:offlineTime] > 0) {
        return NO;
    }
    
    NSDate *onlineTime = self.hmjson[@"onlineTime"].date;
    if ([now timeIntervalSinceDate:onlineTime] < 0) {
        return NO;
    }
    
    return YES;
}

- (HMServiceAPIStickerBadge )api_stickerBadge {
    NSString *badgeString = self.hmjson[@"angleType"].string;
    if ([badgeString isEqualToString:@"Hot"]) {
        return HMServiceAPIStickerBadgeHot;
    }
    
    return HMServiceAPIStickerBadgeNew;
}

- (NSString *)api_stickerTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_stickerBlackWatermarkURL {
    return self.hmjson[@"watermarkBlackPicUrl"].string;
}

- (NSString *)api_stickerWhiteWatermarkURL {
    return self.hmjson[@"watermarkWhitePicUrl"].string;
}

- (CGRect)api_stickerWatermarkFrame {
    
    CGFloat ratio = 1080.f / [UIScreen mainScreen].bounds.size.width;
    
    CGFloat x = self.hmjson[@"watermarkPicX"].doubleValue / ratio;
    CGFloat y = self.hmjson[@"watermarkPicY"].doubleValue / ratio;
    CGFloat w = self.hmjson[@"watermarkPicWidth"].doubleValue / ratio;
    CGFloat h = self.hmjson[@"watermarkPicHeight"].doubleValue / ratio;
    
    return CGRectMake(x, y, w, h);
}

- (NSArray<id<HMServiceAPIStickerContent>> *)api_stickerContents {
    
    NSDictionary *dictionary = self.hmjson[@"dataType"].dictionary;
    if (!dictionary) {
        return nil;
    }
    
    NSMutableArray *contents = [NSMutableArray new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL * _Nonnull stop) {
        if (key.length == 0 ||
            !obj) {
            return;
        }
        
        NSMutableDictionary *content = [obj mutableCopy];
        content[@"type"] = key;
        
        [contents addObject:content];
    }];
    
    return contents;
}

@end
