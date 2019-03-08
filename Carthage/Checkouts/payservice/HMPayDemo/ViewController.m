//  ViewController.m
//  Created on 2018/3/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "ViewController.h"
#import "HMPay.h"
#import "HMTestOrder.h"

@interface ViewController ()

@property (strong, nonatomic) HMTestOrder *testOrder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testOrder = [[HMTestOrder alloc] init];
}

// 微信支付
- (IBAction)wxPay:(id)sender {
    [self startPay:HMPayTypeWxPay];
}

//支付宝
- (IBAction)aliPay:(id)sender {
    [self startPay:HMPayTypeAliPay];
}

- (void)startPay:(HMPayType)type {
    [[HMPay defaultPay] pay:type order:self.testOrder payHandler:^(HMPayResultStatus status, NSDictionary * _Nullable resultInfo, NSString * _Nullable error) {
        if (status == HMPayResultStatusSuccess) {
            NSLog(@"支付成功 success.\n");
        } else if (status == HMPayResultStatusFailure) {
            NSLog(@"支付失败. \n");
        } else if (status == HMPayResultStatusCancel) {
            NSLog(@"支付取消. \n");
        }
        NSLog(@"pay Handler: %@, error: %@",resultInfo, error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                              
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}
@end
