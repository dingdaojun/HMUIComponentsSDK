//  RNViewController.m
//  Created on 2018/6/15
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "RNViewController.h"
#import <React/RCTRootView.h>

@interface RNViewController ()

@property (weak, nonatomic) IBOutlet UIView *RNView;

@end

@implementation RNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RN测试";
}
// 在线加载RN
- (IBAction)loadRNView:(id)sender {
    NSString *strURL = @"http://10.8.6.178:8081/index.ios.bundle?platform=ios&dev=true";
    NSURL * jsCodeLocation = [NSURL URLWithString:strURL];
    RCTRootView * rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"HMReactNativeDemo"
                                                  initialProperties:nil
                                                      launchOptions:nil];
    self.RNView = rootView;
    
}
// 离线包加载
- (IBAction)offLineLoadRN:(id)sender {
    /*
    NSString *jsBundlePath = [[NSBundle mainBundle] pathForResource:@"main.jsbundle" ofType:nil];
    NSURL * jsCodeLocation = [NSURL URLWithString:jsBundlePath];
    RCTRootView * rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                         moduleName:@"HMReactNativeDemo"
                                                  initialProperties:nil
                                                      launchOptions:nil];
    self.RNView = rootView;
     */
}

@end
