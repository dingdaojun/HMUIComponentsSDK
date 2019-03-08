//
//  NSURLSessionTask+CURL.m
//  HMNetworkLayer
//
//  Created by 李宪 on 18/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "NSURLSessionTask+CURL.h"

@implementation NSURLSessionTask (CURL)

- (NSString *)CURLCommand {
    
    NSURLRequest *request = self.originalRequest ?: self.currentRequest;
    
    NSMutableArray *components = [NSMutableArray new];
    [components addObject:@"$ curl -i"];
    
    NSURL *URL = request.URL;

    // Method
    if (![request.HTTPMethod isEqualToString:@"GET"]) {
        NSString *methodLine = [NSString stringWithFormat:@"-X %@", request.HTTPMethod];
        [components addObject:methodLine];
    }

    // Header fields
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *headerLine = [NSString stringWithFormat:@"-H \"%@:%@\" ", key, obj];
        [components addObject:headerLine];
    }];

    // Body
    NSData *bodyData = nil;
    if (request.HTTPBody) {
        bodyData = request.HTTPBody;
    }
    else if (request.HTTPBodyStream) {
        if ([request.HTTPBodyStream respondsToSelector:@selector(copy)]) {
            NSInputStream *stream = [request.HTTPBodyStream copy];
            [stream open];

            NSMutableData *streamData = [NSMutableData data];

            Byte *readBuffer = malloc(sizeof(Byte) * 1024);

            for (;;) {
                NSInteger readLength = [stream read:readBuffer maxLength:1024];
                if (readBuffer <= 0) {
                    break;
                }

                [streamData appendBytes:readBuffer length:readLength];
            }

            free(readBuffer);
            [stream close];

            bodyData = streamData;
        }
    }

    if (bodyData) {
        NSString *httpBody = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        NSString *escaptedBody = [httpBody stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\\\\\""];
        escaptedBody = [escaptedBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

        NSString *bodyLine = [NSString stringWithFormat:@"-d \"%@\"", escaptedBody];
        [components addObject:bodyLine];
    }

    // URL
    NSString *URLLine = URL.absoluteString;
    if ([URLLine hasPrefix:@"http:/"] && ![URLLine hasPrefix:@"http://"]) {
        URLLine = [URLLine stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
    }
    else if ([URLLine hasPrefix:@"https:/"] && ![URLLine hasPrefix:@"https://"]) {
        URLLine = [URLLine stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    URLLine = [NSString stringWithFormat:@"\"%@\"", URLLine];
    [components addObject:URLLine];
    
    NSString *command   = [components componentsJoinedByString:@" \\\n\t"];
    command             = [command stringByAppendingString:@"\n"];
    return command;
}

@end
