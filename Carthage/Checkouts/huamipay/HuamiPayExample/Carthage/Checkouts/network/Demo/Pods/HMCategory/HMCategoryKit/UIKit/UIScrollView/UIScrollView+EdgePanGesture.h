//
//  @fileName  UIScrollView+EdgePanGesture.h
//  @abstract  对于一个横向滚动的UIScrollView，如果要让其在滚动到最左（scrollOffset.x == 0）的时候支持侧滑返回上个页面，就调用enableEdgePanGesture。
//  @author    李宪 创建于 2017/5/10.
//  @revise    李宪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIScrollView (EdgePanGesture)


/**
 开启
 */
- (void)enableEdgePanGesture;

/**
 关闭
 */
- (void)disableEdgePanGesture;

@end
