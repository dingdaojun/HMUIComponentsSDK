//
//  @fileName  UIButton+EnlargeTouchArea.h
//  @abstract  按钮点击范围调整
//  @author    李宪 创建于 2017/5/10.
//  @revise    李宪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIButton (EnlargeTouchArea)


/**
 设置按钮点击边界

 @param edge CGFloat
 */
- (void)setEnlargeEdge:(CGFloat)edge;

/**
 设置四个方向的边界

 @param top top
 @param right right
 @param bottom bottom
 @param left left
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
