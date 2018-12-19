//
//  UIView+HMConvertToImage.m
//  MiFit
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2016年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIView+HMConvertToImage.h"


@implementation UIView (HMConvertToImage)


#pragma mark 转Image
- (UIImage *)toImage {
    return [UIView toImageFromView:self withFrame:self.frame];
}

#pragma mark 转Image
- (UIImage *)toImageWithFrame:(CGRect)frame {
    return [UIView toImageFromView:self withFrame:frame];
}

#pragma mark 父View转Image
- (UIImage *)toImageFromSuperView {
    return [UIView toImageFromView:self.superview withFrame:self.frame];
}

#pragma mark 公类(将View转Image)
+ (UIImage *)toImageFromView:(UIView *)view withFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    UIRectClip(frame);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 将ScrollView转Image
- (UIImage *)toImageFromScrollView {
    if (![self isKindOfClass:[UIScrollView class]]) {
        return nil;
    }
    
    UIScrollView *scrollSelf = (UIScrollView*)self;
    
    if (scrollSelf.contentSize.height <= scrollSelf.bounds.size.height) {
        return [scrollSelf toImageFromSuperView];
    }
    
    CGPoint originOffset = scrollSelf.contentOffset;
    CGPoint currentOffset = CGPointZero;
    CGFloat scrollViewHeight = scrollSelf.bounds.size.height;
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    
    while (scrollSelf.contentSize.height > currentOffset.y) {
        scrollSelf.contentOffset = currentOffset;
        UIImage *image = [scrollSelf toImageFromSuperView];
        currentOffset.y += scrollViewHeight;
        [images addObject:image];
    }

    UIGraphicsBeginImageContextWithOptions(scrollSelf.contentSize, YES, [UIScreen mainScreen].scale);
    
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage *image = images[i];
        [image drawAtPoint:CGPointMake(0, i * scrollViewHeight)];
    }
    
    UIImage *unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scrollSelf.contentOffset = originOffset;
    return unifiedImage;
}

@end
