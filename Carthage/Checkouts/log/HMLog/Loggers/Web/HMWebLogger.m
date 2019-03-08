//
//  HMWebLogger.m
//  HMLog
//
//  Created by 李宪 on 13/1/2017.
//  Copyright © 2017 李宪. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <SystemConfiguration/SystemConfiguration.h>
#endif

#import "HMWebLogger.h"
#import "HMLogItem.h"


#import "GCDWebServerDataRequest.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerErrorResponse.h"


@interface HMWebLogger ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

@property (nonatomic, strong) NSMutableArray<HMLogItem *> *cachedItems;

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#else
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#endif  /* OS_OBJECT_USE_OBJC */

@end

@implementation HMWebLogger

+ (void)initialize {
    [self setLogLevel:4];
}

- (instancetype)initWithPort:(NSUInteger)port {
    if ((self = [super init])) {
        
        _ioQueue = dispatch_queue_create("HMWebLogger.ioQueue", DISPATCH_QUEUE_SERIAL);
        
        NSString *bundlePath = [[NSBundle bundleForClass:[HMWebLogger class]] pathForResource:@"HMWebLogger" ofType:@"bundle"];
        NSBundle *siteBundle = [NSBundle bundleWithPath:bundlePath];
        NSAssert(siteBundle, @"WebLogger cannot find resource bundle");
        
        // Resource files
        [self addGETHandlerForBasePath:@"/"
                         directoryPath:siteBundle.resourcePath
                         indexFilename:nil
                              cacheAge:3600
                    allowRangeRequests:NO];
        
        __weak typeof(self) server = self;
        
        
        
        // Web page
        [self addHandlerForMethod:@"GET"
                             path:@"/"
                     requestClass:[GCDWebServerRequest class]
                     processBlock:^GCDWebServerResponse*(GCDWebServerRequest* request) {
                         
#if TARGET_OS_IPHONE
                         NSString *device = UIDevice.currentDevice.name;
#else
                         NSString *device = CFBridgingRelease(SCDynamicStoreCopyComputerName(NULL, NULL));
#endif
                         
                         NSString *title = server.title;
                         if (title == nil) {
                             title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
                             if (title == nil) {
                                 title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                             }
#if !TARGET_OS_IPHONE
                             if (title == nil) {
                                 title = [[NSProcessInfo processInfo] processName];
                             }
#endif
                         }
                         NSString* header = server.header;
                         if (header == nil) {
                             header = title;
                         }
                         
                         NSString* footer = server.footer;
                         if (footer == nil) {
                             NSString* name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
                             NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#if !TARGET_OS_IPHONE
                             if (!name && !version) {
                                 name = @"OS X";
                                 version = [[NSProcessInfo processInfo] operatingSystemVersionString];
                             }
#endif
                             footer = [NSString stringWithFormat:[siteBundle localizedStringForKey:@"FOOTER_FORMAT" value:@"" table:nil], name, version];
                         }
                         return [GCDWebServerDataResponse responseWithHTMLTemplate:[siteBundle pathForResource:@"index" ofType:@"html"]
                                                                         variables:@{
                                                                                     @"device" : device,
                                                                                     @"title" : title,
                                                                                     @"header" : header,
                                                                                     @"footer" : footer
                                                                                     }];
                         
                     }];
        
        // File listing
        [self addHandlerForMethod:@"GET"
                             path:@"/list"
                     requestClass:[GCDWebServerRequest class]
                     processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                         return [server handleLogListRequest:request];
                     }];
        
        [self startWithPort:port bonjourName:nil];
        printf("HMWebLogger started on port %i and reachable at %s\n\n", (int)self.port, self.serverURL.absoluteString.UTF8String);
    }
    return self;
}

#pragma mark - private

- (NSString *)dateTextWithItem:(HMLogItem *)item {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
    
    return [formatter stringFromDate:item.time];
}

- (GCDWebServerResponse *)handleLogListRequest:(GCDWebServerRequest *)request {
    
    __block NSArray *items;
    
    dispatch_sync(_ioQueue, ^{
        items = [self.cachedItems copy];
        [self.cachedItems removeAllObjects];
    });
    
    NSMutableArray *array = [NSMutableArray new];
    for (HMLogItem *item in items) {
        
        NSString *content = item.content;
        if (item.stackSymbols.length > 0) {
            content = [content stringByAppendingFormat:@"\n\nStack symbols are: \n%@", item.stackSymbols];
        }
        
        [array addObject:@{@"timestamp" : @(item.time.timeIntervalSince1970),
                           @"level" : item.levelText,
                           @"tag" : item.tag,
                           @"trace" : item.function,
                           @"content" : content,
                           }];
    }
    
    return [GCDWebServerDataResponse responseWithJSONObject:array];
}

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {
    
    dispatch_async(_ioQueue, ^{
        [self.cachedItems addObject:item];
        
        NSUInteger maxCachedItems = 1000;
        if (self.cachedItems.count > maxCachedItems) {
            [self.cachedItems removeObjectsInRange:NSMakeRange(0, self.cachedItems.count - maxCachedItems)];
        }
    });
}

#pragma mark - setters and getters

- (NSMutableArray<HMLogItem *> *)cachedItems {
    if (!_cachedItems) {
        _cachedItems = [NSMutableArray array];
    }
    return _cachedItems;
}

@end
