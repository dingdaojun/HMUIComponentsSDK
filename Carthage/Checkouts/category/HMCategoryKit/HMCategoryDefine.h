//  HMCategoryDefine.h
//  Created on 2018/11/16
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#ifndef HMCategoryDefine_h
#define HMCategoryDefine_h

static inline void category_swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    if (originalMethod == NULL || swizzledMethod == NULL) {  return; }
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static inline void category_swizzling_exchangeClassMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector) {
    category_swizzling_exchangeMethod(object_getClass((id)clazz), originalSelector, swizzledSelector);
}

#endif /* HMCategoryDefine_h */
