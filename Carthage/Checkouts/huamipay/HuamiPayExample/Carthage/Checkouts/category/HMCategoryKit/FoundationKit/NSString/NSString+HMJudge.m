//
//  NSString+HMJudge.m
//  Pods
//
//  Created by 余彪 on 2017/5/8.
//
//

#import "NSString+HMJudge.h"
#import "NSString+HMAdjust.h"


@implementation NSString (HMJudge)


#pragma mark 字符串是否为空
+ (BOOL)isEmpty:(NSString *)string {
    if (!string) {
        return YES;
    }
    
    return ([[string trimAllSpace] isEqualToString:@""] || [string isEqualToString:@"(null)"]) ? YES : NO;
}

#pragma mark 字符串是否为整型
- (BOOL)isPureInt {
    if ([NSString isEmpty:self]) {
        return NO;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 字符串是否为浮点型
- (BOOL)isPureFloat {
    if ([NSString isEmpty:self]) {
        return NO;
    }
    
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    BOOL isFloat = [scan scanFloat:&val] && [scan isAtEnd];
    
    return isFloat;
}

#pragma mark 字符串是否为有效邮箱地址
- (BOOL)isValidEmail {
    if ([NSString isEmpty:self]) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTestPredicate evaluateWithObject:self];
}

#pragma mark 字符串是否为有效URL地址
- (BOOL)isValidURL {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

#pragma mark 字符串是否只包含数字
- (BOOL)isOnlyContainNumber {
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

@end
