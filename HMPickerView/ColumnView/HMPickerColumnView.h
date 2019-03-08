//
//  HMPickerColumnView.h
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import <UIKit/UIKit.h>

@interface HMPickerColumnView : UIView

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelSubUnitTitle;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *labelTitleCenterXConstraint;

@property (nonatomic, weak) IBOutlet UIView *topLineView;
@property (nonatomic, weak) IBOutlet UIView *bottomLineView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLineHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitBottomConstraint;

- (void)setColumnSeparatorColor:(UIColor *)color;

@end
