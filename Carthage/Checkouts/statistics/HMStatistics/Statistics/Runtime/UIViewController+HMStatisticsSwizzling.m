//  UIViewController+HMStatisticsSwizzling.h
//  Created on 2018/4/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "UIViewController+HMStatisticsSwizzling.h"
#import <objc/runtime.h>
#import "HMStatisticsAnonymousAutoCal.h"
#import "HMStatisticsPageAutoTracker.h"

@implementation UIViewController (HMStatisticsSwizzling)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        // Step 1 Swizzling willAppear

        SEL originalAppearSelector = @selector(viewWillAppear:);
        SEL swizzledAppearSelector = @selector(hmStatisticsSwizzling_viewWillAppear:);

        Method originalAppearMethod = class_getInstanceMethod(class, originalAppearSelector);
        Method swizzledAppearMethod = class_getInstanceMethod(class, swizzledAppearSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalAppearSelector,
                        method_getImplementation(swizzledAppearMethod),
                        method_getTypeEncoding(swizzledAppearMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledAppearSelector,
                                method_getImplementation(originalAppearMethod),
                                method_getTypeEncoding(originalAppearMethod));
        } else {
            method_exchangeImplementations(originalAppearMethod, swizzledAppearMethod);
        }


        // Step 2 Swizzling viewWillDisappear:

        SEL originalDisappearSelector = @selector(viewWillDisappear:);
        SEL swizzledDisappearSelector = @selector(hmStatisticsSwizzling_viewWillDisappear:);

        Method originalDisappearMethod = class_getInstanceMethod(class, originalDisappearSelector);
        Method swizzledDisappearMethod = class_getInstanceMethod(class, swizzledDisappearSelector);

        didAddMethod =
        class_addMethod(class,
                        originalDisappearSelector,
                        method_getImplementation(swizzledDisappearMethod),
                        method_getTypeEncoding(swizzledDisappearMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledDisappearSelector,
                                method_getImplementation(originalDisappearMethod),
                                method_getTypeEncoding(originalDisappearMethod));
        } else {
            method_exchangeImplementations(originalDisappearMethod, swizzledDisappearMethod);
        }
    });
}



#pragma mark - Method Swizzling

- (void)hmStatisticsSwizzling_viewWillAppear:(BOOL)animated {
    [self hmStatisticsSwizzling_viewWillAppear:animated];

    const char* className = class_getName([self class]);

    if (!className) {
        return;
    }
    
    // Default Value Class Name
    NSString *pageName = [[NSString alloc] initWithCString:className encoding:NSUTF8StringEncoding];
    
    // Inject Page Name
    BOOL confirmProtocol = [self conformsToProtocol:@protocol(HMStatisticsPageAutoTracker)];
    BOOL selectorExist = [self respondsToSelector:@selector(hmStatisticsAutoTrackerPageName)];
    
    if (confirmProtocol && selectorExist) {
        pageName = [self performSelector:@selector(hmStatisticsAutoTrackerPageName)];
    }

    if (!pageName || [pageName isEqualToString:@""]) {
        return;
    }

    if ([self hmStatisticsFilterSystemVC:pageName]) {
        return;
    }

    [[HMStatisticsAnonymousAutoCal sharedInstance] beginPage:pageName];
}

- (void)hmStatisticsSwizzling_viewWillDisappear:(BOOL)animated {
    [self hmStatisticsSwizzling_viewWillDisappear:animated];

    const char* className = class_getName([self class]);

    if (!className) {
        return;
    }
    
    // Default Value Class Name
    NSString *pageName = [[NSString alloc] initWithCString:className encoding:NSUTF8StringEncoding];
    
    // Inject Page Name
    BOOL confirmProtocol = [self conformsToProtocol:@protocol(HMStatisticsPageAutoTracker)];
    BOOL selectorExist = [self respondsToSelector:@selector(hmStatisticsAutoTrackerPageName)];
    
    if (confirmProtocol && selectorExist) {
        pageName = [self performSelector:@selector(hmStatisticsAutoTrackerPageName)];
    }
    
    if (!pageName || [pageName isEqualToString:@""]) {
        return;
    }

    if ([self hmStatisticsFilterSystemVC:pageName]) {
        return;
    }

    [[HMStatisticsAnonymousAutoCal sharedInstance] endPage:pageName];
}

/**
 过滤系统控制器

 @param className 类名
 @return 是非为系统控制器
 */
- (BOOL)hmStatisticsFilterSystemVC:(NSString *)className {

    NSArray *systemVCs = @[@"UIAlertController",
                           @"UIInputWindowController",
                           @"UICompatibilityInputViewController",
                           @"HKHealthPrivacyHostViewController",
                           @"UINavigationController"];

    for (NSString *filterName in systemVCs) {
        if ([filterName isEqualToString:className]) {
            return YES;
        }
    }

    return NO;
}


@end
