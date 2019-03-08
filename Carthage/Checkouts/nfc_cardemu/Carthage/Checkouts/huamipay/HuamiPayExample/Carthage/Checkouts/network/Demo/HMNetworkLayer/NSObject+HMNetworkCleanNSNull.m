//
//  NSObject+HMNetworkCleanNSNull.m
//  HMNetworkLayer
//
//  Created by 李宪 on 12/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSObject+HMNetworkCleanNSNull.h"

@implementation NSObject (HMNetworkCleanNSNull)

- (nullable id)hmn_cleanObject {
    
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self;
        NSMutableArray *cleanArray = [NSMutableArray new];
        for (id object in array) {
            id cleanObject = [object hmn_cleanObject];
            if (cleanObject) {
                [cleanArray addObject:cleanObject];
            }
        }
        
        if (cleanArray.count == 0) {
            return nil;
        }
        
        return cleanArray;
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)self;
        NSMutableDictionary *cleanDictionary = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            id cleanObject = [object hmn_cleanObject];
            if (cleanObject) {
                cleanDictionary[key] = cleanObject;
            }
        }];
        
        if (cleanDictionary.count == 0) {
            return nil;
        }
        
        return cleanDictionary;
    }
    
    return self;
}

@end
