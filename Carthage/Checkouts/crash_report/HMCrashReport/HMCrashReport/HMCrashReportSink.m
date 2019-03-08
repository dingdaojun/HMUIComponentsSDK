//  HMCrashReportSink.m
//  Created on 2018/6/19
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMCrashReportSink.h"
#import <KSCrash/KSHTTPMultipartPostBody.h>
#import <KSCrash/KSHTTPRequestSender.h>
#import <KSCrash/NSData+GZip.h>
#import <KSCrash/KSJSONCodecObjC.h>
#import <KSCrash/KSReachabilityKSCrash.h>
#import <KSCrash/NSError+SimpleConstructor.h>
#import <KSCrash/KSLogger.h>
#import <CommonCrypto/CommonCrypto.h>

static NSInteger const hmCrashSHA1Rounds = 10;     // 加密
static NSString * const hmCrashSHA1Salt = @"thisisasaltfor2018huami";
static const char hmCrashReportBase64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface HMCrashReportSink ()

@property(nonatomic,readwrite,retain) NSURL* url;
@property(nonatomic,readwrite,retain) KSReachableOperationKSCrash* reachableOperation;

@end

@implementation HMCrashReportSink

+ (HMCrashReportSink*)sinkWithURL:(NSURL*)url {
    return [[self alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL*)url {
    if((self = [super init])) {
        self.url = url;
    }
    return self;
}

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet {
    return self;
}

- (void) filterReports:(NSArray*) reports
          onCompletion:(KSCrashReportFilterCompletion) onCompletion {
    
    if (reports.count < 1) {
        kscrash_callCompletion(onCompletion, reports, NO, nil);
        return;
    }
    
    NSError* error = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:15];
    KSHTTPMultipartPostBody* body = [KSHTTPMultipartPostBody body];
    
    NSData* jsonData = [KSJSONCodec encode:reports
                                   options:KSJSONEncodeOptionNone
                                     error:&error];
    if(jsonData == nil) {
        kscrash_callCompletion(onCompletion, reports, NO, error);
        return;
    }
    
    [body appendData:jsonData
                name:@"reports"
         contentType:@"application/json"
            filename:@"reports.json"];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body data];
    
    // Header Setting
    [request setValue:body.contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"HMCrashReporter" forHTTPHeaderField:@"User-Agent"];
    [request setValue:self.appID forHTTPHeaderField:@"appid"];
    
    // Get RawValue Hash Info
    NSString *hashKey = [self generatePBKDF2Key:jsonData];
    [request setValue:hashKey forHTTPHeaderField:@"encrypt"];
    
    self.reachableOperation = [KSReachableOperationKSCrash operationWithHost:[self.url host]
                                                                   allowWWAN:YES
                                                                       block:^
                               {
                                   [[KSHTTPRequestSender sender] sendRequest:request
                                                                   onSuccess:^(__unused NSHTTPURLResponse* response, __unused NSData* data)
                                    {
                                        kscrash_callCompletion(onCompletion, reports, YES, nil);
                                    } onFailure:^(NSHTTPURLResponse* response, NSData* data)
                                    {
                                        NSString* text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        kscrash_callCompletion(onCompletion, reports, NO,
                                                               [NSError errorWithDomain:[[self class] description]
                                                                                   code:response.statusCode
                                                                               userInfo:[NSDictionary dictionaryWithObject:text
                                                                                                                    forKey:NSLocalizedDescriptionKey]
                                                                ]);
                                    } onError:^(NSError* error2)
                                    {
                                        kscrash_callCompletion(onCompletion, reports, NO, error2);
                                    }];
                               }];
}

- (NSString *)generatePBKDF2Key:(NSData *)content{
    // Salt
    NSData *saltData = [hmCrashSHA1Salt dataUsingEncoding:NSUTF8StringEncoding];
    
    //哈希 KEY CC_SHA1_BLOCK_BYTES、CC_SHA1_DIGEST_LENGTH
    NSMutableData *hashKeyData = [NSMutableData dataWithLength:32];
    //按 PBKDF2 标准生成
    CCKeyDerivationPBKDF(kCCPBKDF2, content.bytes, content.length, saltData.bytes, saltData.length, kCCPRFHmacAlgSHA1, hmCrashSHA1Rounds, hashKeyData.mutableBytes, hashKeyData.length);
    
    NSString *hashKey = [self base64EncodedStringWithData:hashKeyData];
    
    return hashKey;
}

- (NSString *)base64EncodedStringWithData:(NSData *)data {
    NSUInteger length = data.length;
    if (length == 0)
        return @"";
    
    NSUInteger out_length = ((length + 2) / 3) * 4;
    uint8_t *output = malloc(((out_length + 2) / 3) * 4);
    if (output == NULL)
        return nil;
    
    const char *input = data.bytes;
    NSInteger i, value;
    for (i = 0; i < length; i += 3) {
        value = 0;
        for (NSInteger j = i; j < i + 3; j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = hmCrashReportBase64EncodingTable[(value >> 18) & 0x3F];
        output[index + 1] = hmCrashReportBase64EncodingTable[(value >> 12) & 0x3F];
        output[index + 2] = ((i + 1) < length)
        ? hmCrashReportBase64EncodingTable[(value >> 6) & 0x3F]
        : '=';
        output[index + 3] = ((i + 2) < length)
        ? hmCrashReportBase64EncodingTable[(value >> 0) & 0x3F]
        : '=';
    }
    
    NSString *base64 = [[NSString alloc] initWithBytes:output
                                                length:out_length
                                              encoding:NSASCIIStringEncoding];
    free(output);
    return base64;
}


@end
