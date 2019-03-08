//
//  NSData+Image.h
//  HMCategorySourceCodeExample
//
//  Created by jinbo on 2018/5/23.
//  Copyright © 2018年 华米科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HMImageFormat) {
    HMImageFormatUndefined = 0,
    HMImageFormatJPEG,
    HMImageFormatPNG,
    HMImageFormatGIF,
    HMImageFormatTIFF,
    HMImageFormatWebP,
    HMImageFormatHEIC
};

@interface NSData (Image)

- (HMImageFormat)getImageFormat;

- (UIImage*)getGIFImage;

@end
