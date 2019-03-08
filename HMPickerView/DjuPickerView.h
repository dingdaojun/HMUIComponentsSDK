//
//  DjuPickerView.h
//
//  Copyright (c) 2013 Derek Ju. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DjuPickerViewDelegate;
@protocol DjuPickerViewDataSource;

@interface DjuPickerView : UIView

@property (assign, nonatomic, readonly) NSInteger selectedRow;

- (void)selectRow:(NSInteger)row;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

// The overlay that denotes which cell is currently targeted
@property (strong, nonatomic) UIView  *overlayCell;
@property (strong, nonatomic) UILabel *overlayCellUnit;

@property (assign, nonatomic) float overlayCellUnitXAdditionalOffset;
@property (assign, nonatomic) float overlayCellUnitYAdditionalOffset;

// Background color for the table view
@property (strong, nonatomic) UIColor *backgroundColor;
// Our delegate
@property (weak, nonatomic) IBOutlet id <DjuPickerViewDelegate> delegate;
// Our data source
@property (weak, nonatomic) IBOutlet id <DjuPickerViewDataSource> dataSource;

- (void)adjustFrame;

@end

@protocol DjuPickerViewDelegate<NSObject>

- (NSString *)djuPickerView:(DjuPickerView*)djuPickerView titleForRow:(NSInteger)row;
- (void)djuPickerView:(DjuPickerView*)djuPickerView didSelectRow:(NSInteger)row;
- (CGFloat)rowHeightForDjuPickerView:(DjuPickerView*)djuPickerView;
- (void)labelStyleForDjuPickerView:(DjuPickerView*)djuPickerView forLabel:(UILabel*)label;
- (void)labelSelectedStyleForDjuPickerView:(DjuPickerView*)djuPickerView forLabel:(UILabel*)label;

@optional
- (void)djuPickerView:(DjuPickerView*)djuPickerView didScrollToRow:(NSInteger)row;
- (NSAttributedString *)djuPickerView:(DjuPickerView*)djuPickerView attributedTitleForRow:(NSInteger)row selectedRow:(NSInteger)selectedRow;

@end

@protocol DjuPickerViewDataSource

- (NSInteger)numberOfRowsInDjuPickerView:(DjuPickerView*)djuPickerView;

@end
