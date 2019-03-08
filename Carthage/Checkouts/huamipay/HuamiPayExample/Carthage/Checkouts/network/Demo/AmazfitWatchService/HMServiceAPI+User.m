//
//  HMServiceAPI+User.m
//  HuamiWatch
//
//  Created by 李宪 on 29/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import "HMServiceAPI+User.h"
#import <HMNetworkLayer/HMNetworkLayer.h>


@implementation HMServiceAPI (User)

- (id<HMCancelableAPI>)user_retrieveUserInfoWithUserID:(NSString *)userID
                                       completionBlock:(void (^)(BOOL, NSString *, id<HMServiceAPIUser>user))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(userID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:userID];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
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
                      
                      // 新用户，返回nil
                      if (error) {
                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                              if (((NSHTTPURLResponse *)response).statusCode == 404) {
                                  !completionBlock ?: completionBlock(YES, nil, nil);
                                  return;
                              }
                          }
                      }
                      
                      [self handleResultForAPI:_cmd
                                 responseError:error
                                      response:response
                                responseObject:responseObject
                             desiredDataFormat:HMServiceResultDataFormatDictionary
                               completionBlock:completionBlock];
                  }];
    }];
}

- (id<HMCancelableAPI>)user_updateAvatar:(UIImage *)avatar
                         completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock {
    
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert([avatar isKindOfClass:[UIImage class]]);
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        if (userID.length == 0) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, @"invalid user id", nil);
                });
            }
            return nil;
        }
        
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:[NSString stringWithFormat:@"/users/%@/apps/%@/fileAccessURIs", userID, bundleIdentifier]];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        NSMutableDictionary *parameters = [@{@"fileName" : @"avatar",
                                             @"fileType" : @"PICTURE"} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription, nil);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self handleResultForAPI:_cmd
                                  responseError:error
                                       response:response
                                 responseObject:responseObject
                              desiredDataFormat:HMServiceResultDataFormatDictionary
                                completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {
                                    if (!success) {
                                        !completionBlock ?: completionBlock(NO, message, nil);
                                        return;
                                    }
                                    
                                    NSString *putURI = data.hmjson[@"putURI"].string;
                                    NSString *getURI = data.hmjson[@"getURI"].string;
                                    
                                    if (putURI.length == 0 ||
                                        getURI.length == 0) {
                                        !completionBlock ?: completionBlock(NO, @"put URI or get URI is nil", nil);
                                        return;
                                    }
                                    
                                    NSData *imageData = UIImageJPEGRepresentation(avatar, 0.2);
                                    [HMNetworkCore uploadRequestWithMethod:HMNetworkHTTPMethodPUT
                                                                       URL:putURI
                                                                  fromData:imageData
                                                           completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                                                               
                                                               [self handleResultForAPI:_cmd
                                                                          responseError:error
                                                                               response:response
                                                                         responseObject:responseObject
                                                                      desiredDataFormat:HMServiceResultDataFormatAny
                                                                        completionBlock:^(BOOL success, NSString *message, id data) {
                                                                            if (!success) {
                                                                                !completionBlock ?: completionBlock(NO, message, nil);
                                                                                return;
                                                                            }
                                                                            
                                                                            completionBlock(YES, message, getURI);
                                                                        }];
                                                           }];
                                }];
                   }];
    }];
}
            
- (id<HMCancelableAPI>)user_updateUser:(id<HMServiceAPIUser>)user
                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock {
 
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        
        NSParameterAssert(user.api_userNickName.length > 0);
        NSParameterAssert(user.api_userBirthday);
        NSParameterAssert(user.api_userGender == HMServiceAPIUserGenderMale ||
                          user.api_userGender == HMServiceAPIUserGenderFemale);
        
        NSParameterAssert(user.api_userHeight > 0);
        NSParameterAssert(user.api_userWeight > 0);
        
        NSString *userID = [self.delegate userIDForService:self];
        NSParameterAssert(userID.length > 0);
        
        NSString *URL = [self.delegate absoluteURLForService:self
                                                referenceURL:nil];
        
        NSError *error = nil;
        NSMutableDictionary *headers = [[self.delegate uniformHeaderFieldValuesForService:self error:&error] mutableCopy];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        NSUInteger gender = user.api_userGender == HMServiceAPIUserGenderMale ? 1 : 0;
        
        NSDateFormatter *dateFormatter  = [NSDateFormatter new];
        dateFormatter.calendar          = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        dateFormatter.dateFormat        = @"yyyy-M";
        NSString *birthdayString        = [dateFormatter stringFromDate:user.api_userBirthday];
        
        NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        
        NSMutableDictionary *parameters = [@{@"userId" : userID,
                                             @"nickName" : user.api_userNickName ?: @"",
                                             @"gender" : @(gender),
                                             @"birthday" : birthdayString ?: @"",
                                             @"height" : @(user.api_userHeight),
                                             @"weight" : @(user.api_userWeight),
                                             @"country" : country ?: @""} mutableCopy];
        
        if (user.api_userAvatarURL.length > 0) {
            parameters[@"iconUrl"] = user.api_userAvatarURL;
        }
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            if (completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO, error.localizedDescription);
                });
            }
            return nil;
        }
        
        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {
                       
                       [self handleResultForAPI:_cmd
                                  responseError:error
                                       response:response
                                 responseObject:responseObject
                              desiredDataFormat:HMServiceResultDataFormatAny
                                completionBlock:^(BOOL success, NSString *message, id data) {
                       
                                    if (!success) {
                                        !completionBlock ?: completionBlock(NO, message);
                                        return;
                                    }
                                    
                                    !completionBlock ?: completionBlock(YES, message);
                                }];
                   }];
    }];
}

@end



@interface NSDictionary (HMServiceAPIUser) <HMServiceAPIUser>
@end

@implementation NSDictionary (HMServiceAPIUser)

- (NSString *)api_userNickName {
    return self.hmjson[@"nickName"].string;
}

- (NSDate *)api_userBirthday {
    return [self.hmjson[@"birthday"] dateWithFormat:@"yyyy-M"];
}

- (HMServiceAPIUserGender)api_userGender {
    NSUInteger gender = self.hmjson[@"gender"].unsignedIntegerValue;
    return gender > 0 ? HMServiceAPIUserGenderMale : HMServiceAPIUserGenderFemale;
}

- (NSString *)api_userAvatarURL {
    return self.hmjson[@"iconUrl"].string;
}

- (double)api_userHeight {
    return self.hmjson[@"height"].doubleValue;
}

- (double)api_userWeight {
    return self.hmjson[@"weight"].doubleValue;
}

@end
