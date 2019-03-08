//
//  ViewController.m
//  HMCrashReportExample
//
//  Created by Karsa Wu on 2018/7/26.
//  Copyright © 2018年 Karsa Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *crashName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.crashName = @[@"访问越界", @"未实现 Selector", @"字典 Crash"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [self.crashName objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crashName.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSArray *arr = @[];
        NSString *str = arr[1];
    }
    
    if (indexPath.row == 1) {
        [self performSelector:@selector(crashSelector)];
    }
    
    if (indexPath.row == 2) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:nil forKey:@"TestKey"];
    }
    
    
}

@end
