//
//  @fileName  NSObject+Async.h
//  @abstract  异步
//  @author    余彪 创建于 2017/5/17.
//  @revise    余彪 最后修改于 2017/5/17.
//  @version   当前版本号 1.0(2017/5/17).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^HM_AsyncCallLeave)(void);
typedef void(^HM_AsyncCallBody)(HM_AsyncCallLeave leave);


@interface NSObject (Async)


/**
 *  Wait to perfom the block, until call leave in body.
 *
 *  @param body Perfom body block, we need call leave in the end of body.
 */
- (void)waitPerfomBlock:(HM_AsyncCallBody)body;

@end
