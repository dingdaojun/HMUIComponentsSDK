//
//  HMServiceAPI+MiDongQuan.h
//  HMNetworkLayer
//
//  Created by 李宪 on 28/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMService/HMService.h>

/**
 发布米动圈返回数据
 */
@protocol HMServiceAPIMiDongQuanData <NSObject>

@property (nonatomic, assign, readonly) BOOL api_miDongQuanContainsSensitiveWords;
@property (nonatomic, copy, readonly) NSString *api_miDongQuanID;

@end


@protocol HMServiceMiDongQuanAPI <HMServiceAPI>

/**
 发布米动圈
 @see http://huami-sport-circle-test.mi-ae.net/swagger-ui.html#!/%E5%B8%96%E5%AD%90%E7%B1%BB%E6%8E%A5%E5%8F%A3/addXMYDPostNewUsingPOST
 @see http://huami-sport-circle-test.mi-ae.net/swagger-ui.html#!/%E5%B8%96%E5%AD%90%E7%B1%BB%E6%8E%A5%E5%8F%A3/addXMYDPostIMGNewUsingPOST
 */
- (void)miDongQuan_publishImage:(UIImage *)image
                        content:(NSString *)content
                completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIMiDongQuanData> miDongQuanData))completionBlock;

@end

@interface HMServiceAPI (MiDongQuan) <HMServiceMiDongQuanAPI>
@end
