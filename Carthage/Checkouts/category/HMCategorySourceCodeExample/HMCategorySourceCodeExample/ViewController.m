//
//  ViewController.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/8.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HMJudge.h"
#import "UIImage+AlphaTint.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"Image-TintColor"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image imageWithAlphaTint:[UIColor blueColor]]];
    imageView.frame = CGRectMake(100, 100, image.size.width, image.size.height);
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
