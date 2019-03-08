//
//  HMServiceAPI+Strava.h
//  AmazfitWatch
//
//  Created by 李宪 on 2018/6/22.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIStravaUserInformation <NSObject>

@property (readonly) NSString *api_stravaUserInformationFirstName;
@property (readonly) NSString *api_stravaUserInformationLastName;
@property (readonly) NSString *api_stravaUserInformationToken;

@end

@protocol HMStravaServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)strava_retrieveUserInformationWithCompletionBlock:(void (^)(BOOL success, NSString *message, BOOL outdated, id<HMServiceAPIStravaUserInformation> information))completionBlock;

- (id<HMCancelableAPI>)strava_authorizeWithCode:(NSString *)code
                                       clientID:(NSString *)clientID
                                   clientSecret:(NSString *)clientSecret
                                completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIStravaUserInformation>information))completionBlock;

@end


@interface HMServiceAPI (Strava) <HMStravaServiceAPI>
@end
