//
//  UIView+HMXib.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "UIView+HMXib.h"


@implementation UIView (HMXib)


#pragma mark 添加xib
- (UIView *)addNibNamed:(NSString *)nibName {
    return [self addNibNamed:nibName owner:self];
}

- (UIView *)addNibNamed:(NSString *)nibName owner:(id)owner {
    return [self addNibNamed:nibName owner:owner bundle:[NSBundle mainBundle]];
}

- (UIView *)addNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle {
    return [self addNibNamed:nibName owner:self bundle:bundle];
}

- (UIView *)addNibNamed:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle {
    if (!owner) {
        return nil;
    }

    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }

    NSArray *xibArray = [bundle loadNibNamed:nibName owner:owner options:nil];

    if (xibArray.count == 0) {
        NSLog(@"addNibNamed:owner: error, 未找到此XIB: %@", nibName);
        return nil;
    }

    UIView *view = xibArray.firstObject;
    return [self addSubviewToFillContent:view];
}

#pragma mark 填满式添加subView
- (UIView *)addSubviewToFillContent:(UIView *)view {
    if (!view) {
        NSLog(@"addSubviewToFillContent: error, subView cannot nil.");
        return nil;
    }
    
    NSDictionary *viewsDictionary = @{ @"view" : view };
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:viewsDictionary]];
    return view;
}

@end
