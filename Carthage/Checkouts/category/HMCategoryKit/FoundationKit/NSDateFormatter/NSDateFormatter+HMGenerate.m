//  NSDateFormatter+HMGenerate.m
//  Created on 2018/11/27
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#import "NSDateFormatter+HMGenerate.h"

static NSDateFormatter *__formatter = nil;

@implementation NSDateFormatter (HMGenerate)

+ (instancetype)formatter {
    if (!__formatter) {
        __formatter = [[NSDateFormatter alloc] init];
        //解决ios系统中关于夏令时导致的问题
        __formatter.lenient = YES;
    }
    return __formatter;
}

@end
