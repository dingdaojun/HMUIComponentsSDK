//
//  HMViewController.m
//  HMStatistics
//
//  Created by BigNerdCoding on 01/11/2018.
//  Copyright (c) 2018 BigNerdCoding. All rights reserved.
//

#import "HMViewController.h"
#import <HMStatistics/HMStatisticsLog.h>
#import <HMStatistics/HMStatisticsPageAutoTracker.h>
#import "HMSubVCViewController.h"
#import "HMSubPresentViewController.h"

@interface HMViewController ()<HMStatisticsPageAutoTracker>

@property (weak, nonatomic) IBOutlet UIButton *endDurationBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDurationBtn;
@property (weak, nonatomic) IBOutlet UIButton *timesBtn;

@end

@implementation HMViewController

-(NSString *)hmStatisticsAutoTrackerPageName {
    return @"ReplacePageName";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushAction:(UIButton *)sender {
    HMSubVCViewController *sub = [[HMSubVCViewController alloc] init];

    [self.navigationController pushViewController:sub animated:YES];
}

- (IBAction)showAction:(UIButton *)sender {
    HMSubPresentViewController *sub  = [[HMSubPresentViewController alloc] init];

    [self presentViewController:sub animated:YES completion:^{

    }];
}

- (IBAction)timesBtnClick:(UIButton *)sender {
    [HMStatisticsLog logEvent:@"TimesTest_V3" extendValue:@{@"attr1":@"attr1",
                                                           @"attr2":@"attr2"} isAnonymous:YES];

    [HMStatisticsLog logEvent:@"NamedTimesTest_V3" extendValue:@{@"attr1":@"attr1",
                                                                @"attr2":@"attr2"} isAnonymous:NO];

    // 线程安全
    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.bignerdcoding.gcd",DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(myConcurrentDispatchQueue, ^{
        [HMStatisticsLog logEvent:@"TimesTest_ThreadV3" extendValue:@{@"attr1":@"attr1",
                                                               @"attr2":@"attr2"} isAnonymous:YES];

        [HMStatisticsLog logEvent:@"NamedTimesTest_ThreadV3" extendValue:@{@"attr1":@"attr1",
                                                                    @"attr2":@"attr2"} isAnonymous:NO];
    });
}

@end
