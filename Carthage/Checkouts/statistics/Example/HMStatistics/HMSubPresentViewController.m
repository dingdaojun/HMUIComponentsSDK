//
//  HMSubPresentViewController.m
//  HMStatistics_Example
//
//  Created by 吴明亮 on 2018/5/24.
//  Copyright © 2018 BigNerdCoding. All rights reserved.
//

#import "HMSubPresentViewController.h"

@interface HMSubPresentViewController ()

@end

@implementation HMSubPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 60, 30)];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.text = @"Dismiss";

    [btn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
