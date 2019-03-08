//
//  HMServiceAPI+Sticker.h
//  HMNetworkLayer
//
//  Created by 李宪 on 19/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HMServiceAPIStickerBadge) {
    HMServiceAPIStickerBadgeNew,
    HMServiceAPIStickerBadgeHot
};

@protocol HMServiceAPIStickerContent;
@protocol HMServiceAPIStickerData <NSObject>

@property (readonly) BOOL api_stickerValid;                                          // 是否有效
@property (readonly) HMServiceAPIStickerBadge api_stickerBadge;                      // 角标的类型
@property (readonly) NSString *api_stickerTitle;                                       // 标题
@property (readonly) NSString *api_stickerBlackWatermarkURL;                           // 黑色水印图片URL
@property (readonly) NSString *api_stickerWhiteWatermarkURL;                           // 白色水印图片URL
@property (readonly) CGRect api_stickerWatermarkFrame;                               // 水印的位置（已经根据手机屏幕尺寸处理）
@property (readonly) NSArray<id<HMServiceAPIStickerContent>> *api_stickerContents;   // 内容

@end

typedef NS_ENUM(NSUInteger, HMServiceAPIStickerContentType) {
    HMServiceAPIStickerContentTypeMileage,      // 里程
    HMServiceAPIStickerContentTypeTime,         // 用时
    HMServiceAPIStickerContentTypePace,         // 配速
    HMServiceAPIStickerContentTypeConsume,      // 消耗
    HMServiceAPIStickerContentTypeHeartRate,    // 心率
    HMServiceAPIStickerContentTypeSteps,        // 步数
    HMServiceAPIStickerContentTypeSpeed,        // 速度
    HMServiceAPIStickerContentTypeCadence,      // 步频
    HMServiceAPIStickerContentTypeStride,       // 步幅
    HMServiceAPIStickerContentTypeAltitude,     // 海拔上升
    HMServiceAPIStickerContentTypeForefoot,     // 前脚掌着地
};

typedef NS_ENUM(NSUInteger, HMServiceAPIStickerContentFontWeight) {
    HMServiceAPIStickerContentFontWeightLight,
    HMServiceAPIStickerContentFontWeightBold,
};

typedef NS_ENUM(NSUInteger, HMServiceAPIStickerContentTextAlignment) {
    HMServiceAPIStickerContentTextAlignTypeCenter = 1,
    HMServiceAPIStickerContentTextAlignTypeLeft,
    HMServiceAPIStickerContentTextAlignTypeRight,
};

@protocol HMServiceAPIStickerContent <NSObject>

@property (readonly) HMServiceAPIStickerContentType api_stickerContentType;
@property (readonly) CGFloat api_stickerContentFontSize;
@property (readonly) HMServiceAPIStickerContentFontWeight api_stickerContentFontWeight;
@property (readonly) HMServiceAPIStickerContentTextAlignment api_stickerContentTextAlignment;
@property (readonly) UIColor *api_stickerContentTextColor;
@property (readonly) UIColor *api_stickerContentTextBackgroundColor;
@property (readonly) CGPoint api_stickerContentTextPoint;

@end


@protocol HMServiceStickerAPI <HMServiceAPI>

/**
 水印相机
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=366
 */
- (id<HMCancelableAPI>)sticker_cameraWatermarksWithLanguage:(NSString *)language
                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIStickerData>> *watermarks))completionBlock;

/**
 水印相机贴纸
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=367
 */
- (id<HMCancelableAPI>)sticker_cameraStickersWithLanguage:(NSString *)language
                                          completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIStickerData>> *stickers))completionBlock;
@end


@interface HMServiceAPI (Sticker) <HMServiceStickerAPI>
@end
