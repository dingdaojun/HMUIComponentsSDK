//
//  HMIDLoginItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMIDUserItem.h"
#import "HMIDRegistItem.h"
#import "HMIDAppTokenItem.h"

@interface HMIDLoginItem : NSObject

@property (nonnull, nonatomic, strong) HMIDAppTokenItem *appTokenItem;
@property (nonnull, nonatomic, strong) HMIDUserItem *userItem;
@property (nonnull, nonatomic, strong) HMIDRegistItem *registItem;

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary;

@end
