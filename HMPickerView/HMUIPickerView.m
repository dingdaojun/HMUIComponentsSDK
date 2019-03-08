//
//  HMUIPickerView.m
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import "HMUIPickerView.h"
#import "HMPickerCommonCell.h"

@implementation HMUIPickerView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (tableView.superview == [tableView.superview.superview.subviews lastObject]) {
        
        HMPickerCommonCell *pickerCommonCell = [[cell.subviews lastObject].subviews firstObject];
        
        if (pickerCommonCell && [pickerCommonCell respondsToSelector:@selector(labelTitle)]) {
            NSDictionary *attributes = [self.hmDelegate selectedAttributesForPickerView:self];
            UILabel *labelTitle = [pickerCommonCell labelTitle];
            labelTitle.font = attributes[NSFontAttributeName];
            labelTitle.textColor = attributes[NSForegroundColorAttributeName];
        }
    }
    return cell;
}

@end
