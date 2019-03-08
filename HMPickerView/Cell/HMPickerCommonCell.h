//
//  HMPickerCommonCell.h
//  MiFit
//
//  Created by ddj on 15/12/2.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMPickerCommonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelTitleRightConstraint;

@end
