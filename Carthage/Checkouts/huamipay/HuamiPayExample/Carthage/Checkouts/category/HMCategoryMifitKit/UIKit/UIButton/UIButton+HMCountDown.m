//
//  UIButton+HMCountDown.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/19.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "UIButton+HMCountDown.h"
#import <objc/runtime.h>


static NSString *HMDisplayLinkKey;
static NSString *HMLaveTimeKey;
static NSString *HMCountDownFormatKey;
static NSString *HMFinishedStringKey;
static NSString *HMShouldChangeStateStringKey;
static NSString *HMTaskIdentifierKey;

@interface UIButton ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign, readwrite) NSTimeInterval leaveTime;

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@end

@implementation UIButton (HMCountDown)

#pragma mark - Public Methods

- (void)countDownWithTimeInterval:(NSTimeInterval) duration{
    self.leaveTime = duration;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDown)];
    self.displayLink.frameInterval=60;
    [self.displayLink  addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)reset{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    self.leaveTime = 0;
    [self setTitle:self.finishedString forState:UIControlStateNormal];
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.enabled = YES;
    [self endBackgroundTask];
}

- (void)stopCountDown{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    self.leaveTime = 0;
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.enabled = YES;
    [self endBackgroundTask];
}

#pragma mark - Private Methods

- (void)countDown{
    self.leaveTime--;
    if (self.shouldChangeString) {
        [self setTitle:[NSString stringWithFormat:self.countDownFormat,(int)self.leaveTime] forState:UIControlStateDisabled];
    }
    if (self.leaveTime == 0) {
        [self stopCountDown];
        if (self.shouldChangeString) {
            [self setTitle:self.finishedString forState:UIControlStateNormal];
        }
    }
}

#pragma mark -  UIApplicationNotification

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification {
    UIApplication *application = notification.object;
    __weak __typeof(&*self)weakSelf = self;
    self.taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:weakSelf.taskIdentifier];
    }];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    [self endBackgroundTask];
}

- (void)endBackgroundTask{
    if (self.taskIdentifier != 0) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
    }
    self.taskIdentifier = 0;
}

#pragma mark - Getter And Setter

- (void)setDisplayLink:(CADisplayLink *)displayLink{
    objc_setAssociatedObject(self, &HMDisplayLinkKey, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CADisplayLink *)displayLink{
    return  objc_getAssociatedObject(self, &HMDisplayLinkKey);
}



- (void)setLeaveTime:(NSTimeInterval)leaveTime{
    objc_setAssociatedObject(self, &HMLaveTimeKey, @(leaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)leaveTime{
    return  [objc_getAssociatedObject(self, &HMLaveTimeKey) doubleValue];
}



- (void)setCountDownFormat:(NSString *)countDownFormat{
    objc_setAssociatedObject(self, &HMCountDownFormatKey, countDownFormat, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)countDownFormat{
    return objc_getAssociatedObject(self, &HMCountDownFormatKey);
}


- (void)setFinishedString:(NSString *)finishedString{
    objc_setAssociatedObject(self, &HMFinishedStringKey, finishedString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)finishedString{
    return objc_getAssociatedObject(self, &HMFinishedStringKey);
}

- (void)setShouldChangeString:(BOOL)shouldChangeString{
    if (shouldChangeString) {
        [self setTitle:[NSString stringWithFormat:self.countDownFormat,(int)self.leaveTime] forState:UIControlStateDisabled];
    }
    objc_setAssociatedObject(self, &HMShouldChangeStateStringKey, @(shouldChangeString), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)shouldChangeString{
    return [objc_getAssociatedObject(self, &HMShouldChangeStateStringKey) boolValue];
}

- (void)setTaskIdentifier:(UIBackgroundTaskIdentifier)taskIdentifier {
    objc_setAssociatedObject(self, &HMTaskIdentifierKey, @(taskIdentifier), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIBackgroundTaskIdentifier)taskIdentifier{
    return [objc_getAssociatedObject(self, &HMTaskIdentifierKey) unsignedIntegerValue];
}

@end
