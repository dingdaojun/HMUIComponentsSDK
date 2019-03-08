//
//  HMFileLogger.m
//  Mac
//
//  Created by 李宪 on 2018/5/25.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMFileLogger.h"
#import "HMLogItem.h"
#import "HMFileLogFormatter.h"


@interface HMFileLogger ()

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#else
@property (nonatomic, strong) dispatch_queue_t ioQueue;
#endif  /* OS_OBJECT_USE_OBJC */

@end

@implementation HMFileLogger

+ (instancetype)sharedLogger {
    static dispatch_once_t onceToken;
    static HMFileLogger *logger;
    dispatch_once(&onceToken, ^{
        logger = [self new];
    });
    return logger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("HMFileLogger.ioQueue", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
        dispatch_release(_ioQueue);
#endif
}

#pragma mark - HMLogger

- (void)recordLogItem:(HMLogItem *)item {

    dispatch_async(_ioQueue, ^{
        if (item.dataFileName.length == 0) {
            return;
        }

        NSString *fileName = [self fileNameForItem:item];
        FILE *file = fopen(fileName.UTF8String, "a+");
        NSParameterAssert(NULL != file);
        if (NULL == file) {
            return;
        }

        if (!self.formatter) {
            self.formatter = [HMFileLogFormatter new];
        }

        NSString *formattedText = [self.formatter formattedTextWithItem:item];
        NSData *data            = [formattedText dataUsingEncoding:NSUTF8StringEncoding];

        fwrite(data.bytes, sizeof(Byte), data.length, file);

        fclose(file);
    });
}

- (NSString *)fileNameForItem:(HMLogItem *)item {
    NSParameterAssert(item.dataFileName.length > 0);
    return [self.directory stringByAppendingPathComponent:item.dataFileName];
}

#pragma mark - Lazy

- (NSString *)directory {
    if (_directory.length == 0) {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = directories.firstObject;
        NSString *rootDirectory = [cacheDirectory stringByAppendingPathComponent:@"HMLog"];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:rootDirectory]) {
            [fileManager createDirectoryAtPath:rootDirectory
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:NULL];
        }

        _directory = rootDirectory;
    }
    return _directory;
}

@end
