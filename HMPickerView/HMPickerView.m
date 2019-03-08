//
//  HMPickerView.m
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import "HMPickerView.h"
#import "HMPickerViewCell.h"
#import <objc/runtime.h>
#import "HMUIPickerView.h"
#import "HMDesignTools.h"
@import HMCategory;
#import "UIColor+HMCommonColors.h"

@interface HMPickerView () <UICollectionViewDataSource, UICollectionViewDelegate, DjuPickerViewDelegate, DjuPickerViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, HMUIPickerViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *initialRowDictionary;
@property (strong, nonatomic) UIView *xibContent;
@property (strong, nonatomic) NSMutableDictionary *isColumnLabelsAdded;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTitleHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *labelTitleSeparatorView;

@end

@implementation HMPickerView

#pragma mark - Initializers -

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.collectionView registerNib:[UINib nibWithNibName:@"HMPickerViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMPickerViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HMUIPickerViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMUIPickerViewCell"];
}

#pragma mark - Initialize -

- (void)initialize {

    _xibContent = [self addNibNamed:@"HMPickerView"];
    
    self.leftPickerColumnView = [[NSBundle mainBundle] loadNibNamed:@"HMActionSheetPickerSingleColumnView" owner:self options:nil].firstObject;
    self.rightPickerColumnView = [[NSBundle mainBundle] loadNibNamed:@"HMActionSheetPickerSingleColumnView" owner:self options:nil].firstObject;
    
    _xibContent.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.isColumnLabelsAdded = [NSMutableDictionary dictionary];
    self.initialRowDictionary = [NSMutableDictionary dictionary];
    
    self.separatorWidthConstraint.constant = HMDesignTools.designPixelSize;
    self.separatorHeightConstraint.constant = HMDesignTools.designPixelSize;
    
    if ([UIDevice isPhone5_5InchDevice]) {
        self.labelTitleSeparatorView.backgroundColor = [UIColor blackColorWithAlpha:0.4];
        self.separatorView.backgroundColor = [UIColor blackColorWithAlpha:0.4];
    } else {
        self.labelTitleSeparatorView.backgroundColor = [UIColor whiteColorWithAlpha:0.2];
        self.separatorView.backgroundColor = [UIColor whiteColorWithAlpha:0.2];
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width / [self collectionView:collectionView numberOfItemsInSection:0], collectionView.bounds.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = [self.dataSource numberOfComponentsInPickerView:self];
    if (number > 1) {
        if (self.separatorView.hidden == YES) {
            self.separatorView.hidden = NO;
        }
    } else {
        if (self.separatorView.hidden == NO) {
            self.separatorView.hidden = YES;
        }
    }
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = nil;
    
    BOOL useUIPickerView = [self.dataSource useUIPickerViewInPickerView:self];
    
    if (useUIPickerView) {
        CellIdentifier = @"HMUIPickerViewCell";
    } else {
        CellIdentifier = @"HMPickerViewCell";
    }
    
    HMPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    if (indexPath.row == 1) {
//        cell.backgroundColor = [UIColor clearColor];
//        
//    } else {
//        cell.backgroundColor = [UIColor clearColor];
//    }
    
    NSNumber *initialRowNumber = [self.initialRowDictionary objectForKey:@(indexPath.item)];
    
    if (useUIPickerView) {
        cell.uiPickerView.dataSource = self;
        cell.uiPickerView.delegate = self;
        cell.uiPickerView.indexPath = [self exchangeIndexPath:indexPath.item];
        cell.uiPickerView.hmDelegate = self;
        if (initialRowNumber) {
            [cell.uiPickerView selectRow:[initialRowNumber integerValue] inComponent:0 animated:NO];
        }
    } else {
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
        cell.pickerView.indexPath = indexPath;
        [self configureDjuPickerView:cell.pickerView];
        if (initialRowNumber) {
            [cell.pickerView selectRow:[initialRowNumber integerValue] animated:NO];
        }
    }
    
    if (initialRowNumber) {
        [self.initialRowDictionary removeObjectForKey:@(indexPath.item)];
    }
    
    return cell;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSIndexPath *indexPath = pickerView.indexPath;
    
    return [self.dataSource pickerView:self numberOfRowsInComponent:indexPath.item];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [self widthForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return  [self.delegate pickerView:self rowHeightForComponent:pickerView.indexPath.item];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:pickerView.indexPath.item];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    [self configurePickerView:pickerView];
    return [self.delegate pickerView:self viewForRow:row forComponent:pickerView.indexPath.item reusingView:view];
}

- (NSDictionary *)selectedAttributesForPickerView:(HMUIPickerView *)pickerView {
    return [self.delegate selectedAttributesForPickerView:self];
}

#pragma mark - DjuPickerViewDataSource, DjuPickerViewDelegate -

- (NSInteger)numberOfRowsInDjuPickerView:(DjuPickerView*)djuPickerView {
    NSIndexPath *indexPath = djuPickerView.indexPath;
    
    return [self.dataSource pickerView:self numberOfRowsInComponent:indexPath.item];
}

- (NSString *)djuPickerView:(DjuPickerView*)djuPickerView titleForRow:(NSInteger)row {
    return [self.delegate pickerView:self titleForRow:row forComponent:djuPickerView.indexPath.item];
}

- (void)labelSelectedStyleForDjuPickerView:(DjuPickerView*)djuPickerView forLabel:(UILabel*)label {
    NSDictionary *attributes = [self.delegate selectedAttributesForPickerView:self];
    
    label.font = attributes[NSFontAttributeName];
    label.textColor = attributes[NSForegroundColorAttributeName];
}

- (void)labelStyleForDjuPickerView:(DjuPickerView*)djuPickerView forLabel:(UILabel*)label {
    NSDictionary *attributes = [self.delegate attributesForPickerView:self];
    
    label.font = attributes[NSFontAttributeName];
    label.textColor = attributes[NSForegroundColorAttributeName];
}

//- (NSAttributedString *)djuPickerView:(DjuPickerView*)djuPickerView attributedTitleForRow:(NSInteger)row selectedRow:(NSInteger)selectedRow {
//    return [self.delegate pickerView:self attributedTitleForRow:row forComponent:djuPickerView.indexPath.row];
//}

- (CGFloat)rowHeightForDjuPickerView:(DjuPickerView*)djuPickerView {
    return  [self.delegate pickerView:self rowHeightForComponent:djuPickerView.indexPath.item];
}

- (void)djuPickerView:(DjuPickerView*)djuPickerView didSelectRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        NSInteger numberOfRows = [self.dataSource pickerView:self numberOfRowsInComponent:djuPickerView.indexPath.item];
        NSInteger actualRow;
        
        if (row >= numberOfRows) {
            actualRow = numberOfRows - 1;
        } else if (row < 0) {
            actualRow = 0;
        } else {
            actualRow = row;
        }
        [self.delegate pickerView:self didSelectRow:actualRow inComponent:djuPickerView.indexPath.item];
    }
}

#pragma mark - Public methods -

- (void)setTitle:(NSString *)title {
    _title = title;

    if (title.length > 0) {
        self.labelTitle.text = title;
        self.labelTitle.hidden = NO;
        self.labelTitleHeightConstraint.constant = 58;
    } else {
        self.labelTitle.text = nil;
        self.labelTitle.hidden = YES;
        self.labelTitleHeightConstraint.constant = 0;
    }
}

- (void)reloadAllComponents {
    for (NSInteger i = 0; i < [self.dataSource numberOfComponentsInPickerView:self]; i ++) {
        HMPickerViewCell *cell = (HMPickerViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cell.uiPickerView reloadAllComponents];
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    HMPickerViewCell *cell = (HMPickerViewCell *)[self.collectionView cellForItemAtIndexPath: [self exchangeIndexPath:component]];
    return [cell.uiPickerView selectedRowInComponent:0];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    HMPickerViewCell *cell = (HMPickerViewCell *)[self.collectionView cellForItemAtIndexPath:[self exchangeIndexPath:component]];
    
    if (cell) {
        if (row < 0) {
            row = 0;
        }
        if ([self.dataSource useUIPickerViewInPickerView:self]) {
            [cell.uiPickerView selectRow:row inComponent:0 animated:animated];
        } else {
            [cell.pickerView selectRow:row animated:animated];
        }
    } else {
        [self.initialRowDictionary setObject:@(row) forKey:@(component)];
    }
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    if ([self.dataSource useUIPickerViewInPickerView:self]) {
        return CGSizeMake([self widthForComponent:component], [self.delegate pickerView:self rowHeightForComponent:component]);
    } else {
        return CGSizeMake([self widthForComponent:component], [self rowHeightForDjuPickerView:nil]);
    }
}

#pragma mark - Private methods -

- (CGFloat)widthForComponent:(NSInteger)component {
    return self.bounds.size.width / [self collectionView:self.collectionView numberOfItemsInSection:0];
}

- (void)configureSeparatorLinesForView:(UIView *)view {
    
    if (!view.subviews.count) {
        [view setBackgroundColor:[UIColor clearColor]];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColorWithAlpha:0.2];
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:lineView];
        
        NSDictionary *viewsDictionary = @{ @"lineView" : lineView };
        
        NSDictionary *metricsDictionary = @{ @"lineHeight" : @(HMDesignTools.designPixelSize), @"space" : @([HMDesignTools designScaleValueWithOriginalValue:44]) };
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-space-[lineView]-space-|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lineView(==lineHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    }
}

- (void)configureDjuPickerView:(DjuPickerView *)pickerView {
    
    NSInteger index = pickerView.indexPath.item;
    
    BOOL isColumnLabelsAddedForIndex = [self.isColumnLabelsAdded[@(index)] boolValue];
    
    if (!isColumnLabelsAddedForIndex) {
        
        HMPickerColumnView *xibContent = [[NSBundle mainBundle] loadNibNamed:@"HMPickerSingleColumnView" owner:self options:nil][0];
        
        [xibContent setColumnSeparatorColor:[self.delegate columnSeparatorColorForPickerView:self]];
        xibContent.labelTitle.text = [self.delegate pickerView:self columnTitleForComponent:index];
        xibContent.labelTitle.textColor = [self.delegate pickerView:self columnTitleColorForComponent:index];
        xibContent.labelTitleCenterXConstraint.constant = [self.delegate pickerView:self columnTitleOffsetXForComponent:index];
        
        NSDictionary *viewsDictionary = @{ @"xibContent" : xibContent };
        
        NSDictionary *metricsDictionary = @{ @"xibHeight" : @([self rowHeightForDjuPickerView:pickerView]) };
        
        xibContent.translatesAutoresizingMaskIntoConstraints = NO;
        [pickerView addSubview:xibContent];
        
        [pickerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[xibContent]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [xibContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[xibContent(==xibHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
        [pickerView addConstraint:[NSLayoutConstraint constraintWithItem:xibContent attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:pickerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        self.isColumnLabelsAdded[@(index)] = @(YES);
    }
}

- (void)configurePickerView:(UIPickerView *)pickerView {
    
    NSArray *pickerViewSubviews = pickerView.subviews;
    UIView *firstLineView = pickerViewSubviews[pickerViewSubviews.count - 1];
    UIView *secondLineView = pickerViewSubviews[pickerViewSubviews.count - 2];
    
    BOOL isFirstLineViewUp = firstLineView.frame.origin.y < secondLineView.frame.origin.y;
    
    if (!isFirstLineViewUp) {
        firstLineView = pickerViewSubviews[pickerViewSubviews.count - 2];
        secondLineView = pickerViewSubviews[pickerViewSubviews.count - 1];;
    }
    
    NSInteger index = pickerView.indexPath.item;
    
    BOOL isColumnLabelsAddedForIndex = [self.isColumnLabelsAdded[@(index)] boolValue];
    
    if (!isColumnLabelsAddedForIndex) {
        firstLineView.backgroundColor = [UIColor blackColorWithAlpha:0.2];
        secondLineView.backgroundColor = [UIColor blackColorWithAlpha:0.2];
        
        HMPickerColumnView *pickerColumnView;
        if (index == 0) {
            pickerColumnView = self.leftPickerColumnView;
        } else {
            pickerColumnView = self.rightPickerColumnView;
        }
        [self configurePickerColumnView:pickerColumnView forComponent:index inFirstLineView:firstLineView secondLineView:secondLineView];

        self.isColumnLabelsAdded[@(index)] = @(YES);
    }
}

- (void)configurePickerColumnView:(HMPickerColumnView *)pickerColumnView
                     forComponent:(NSInteger)component
                  inFirstLineView:(UIView *)firstLineView
                   secondLineView:(UIView *)secondLineView {
    pickerColumnView.backgroundColor = [UIColor clearColor];
    
    pickerColumnView.labelTitle.text = [self.delegate pickerView:self columnTitleForComponent:component];
    pickerColumnView.labelTitleCenterXConstraint.constant = [self.delegate pickerView:self columnTitleOffsetXForComponent:component];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(firstLineView, pickerColumnView, secondLineView);
    NSDictionary *metricsDictionary = @{ @"firstLineViewY" : @(firstLineView.frame.origin.y),
                                         @"height" : @(secondLineView.frame.origin.y - firstLineView.frame.origin.y) };
    
    pickerColumnView.translatesAutoresizingMaskIntoConstraints = NO;
    [firstLineView.superview addSubview:pickerColumnView];
    [firstLineView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstLineView][pickerColumnView][secondLineView]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [firstLineView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pickerColumnView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
}

- (NSIndexPath *)exchangeIndexPath:(NSInteger)item {
    NSIndexPath *indexPath;
    if (self.needExchangeComponent) {
        indexPath = [NSIndexPath indexPathForItem:item == 0 ? 1 : 0 inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    }
    return indexPath;
}

@end

static const void *IndexPathKey = &IndexPathKey;

@implementation DjuPickerView (IndexPath)

@dynamic indexPath;

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, IndexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, IndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIPickerView (IndexPath)

@dynamic indexPath;

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, IndexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, IndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
