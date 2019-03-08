//
//  HMServiceAPI+User.h
//  HuamiWatch
//
//  Created by 李宪 on 29/7/2017.
//  Copyright © 2017 Huami. All rights reserved.
//

#import <HMService/HMService.h>

@class UIImage;

typedef NS_ENUM(NSUInteger, HMServiceAPIUserGender) {
    HMServiceAPIUserGenderMale,
    HMServiceAPIUserGenderFemale
};



@protocol HMServiceAPIUser <NSObject>

@property (nonatomic, copy, readonly) NSString *api_userNickName;
@property (nonatomic, strong, readonly) NSDate *api_userBirthday;
@property (nonatomic, assign, readonly) HMServiceAPIUserGender api_userGender;

@property (nonatomic, copy, readonly) NSString *api_userAvatarURL;

@property (nonatomic, assign, readonly) double api_userHeight;
@property (nonatomic, assign, readonly) double api_userWeight;

@end



@protocol HMUserServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)user_retrieveUserInfoWithUserID:(NSString *)userID
                                       completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIUser>user))completionBlock;

- (id<HMCancelableAPI>)user_updateAvatar:(UIImage *)avatar
                         completionBlock:(void (^)(BOOL success, NSString *message, NSString *avatarURL))completionBlock;

- (id<HMCancelableAPI>)user_updateUser:(id<HMServiceAPIUser>)user
                       completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;
   
@end


@interface HMServiceAPI (User) <HMUserServiceAPI>
@end
