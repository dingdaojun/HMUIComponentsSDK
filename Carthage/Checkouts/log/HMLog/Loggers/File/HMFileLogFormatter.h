//
//  HMFileLogFormatter.h
//  Mac
//
//  Created by 李宪 on 2018/5/25.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMLogItem;

@protocol HMFileLogFormatter <NSObject>

- (NSString *)formattedTextWithItem:(HMLogItem *)item;

@end


@interface HMFileLogFormatter : NSObject <HMFileLogFormatter>
@end
