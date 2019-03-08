//
//  NSData+Image.m
//  HMCategorySourceCodeExample
//
//  Created by jinbo on 2018/5/23.
//  Copyright © 2018年 华米科技. All rights reserved.
//

#import "NSData+Image.h"

@implementation NSData (Image)

- (HMImageFormat)getImageFormat {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return HMImageFormatJPEG;
        case 0x89:
            return HMImageFormatPNG;
        case 0x47:
            return HMImageFormatGIF;
        case 0x49:
        case 0x4D:
            return HMImageFormatTIFF;
        case 0x52: {
            if (self.length >= 12) {
                NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return HMImageFormatWebP;
                }
            }
        } break;
        case 0x00: {
            if (self.length >= 12) {
                NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return HMImageFormatHEIC;
                }
            }
        } break;
    }
    return HMImageFormatUndefined;
}

- (UIImage *)getGIFImage {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:self];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:0.1 * count];
    }
    CFRelease(source);
    return animatedImage;
}

@end
