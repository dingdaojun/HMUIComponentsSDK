//
//  DjuPickerView.m
//
//  Copyright (c) 2013 Derek Ju. All rights reserved.
//

#import "DjuPickerView.h"


// Also reference to ....

//http://stackoverflow.com/questions/15527204/custom-uipickerview-and-uidatepicker-flatter-design

//http://www.raywenderlich.com/6567/



@interface DjuPickerView() <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat selectedLineHeight;
    
    CGFloat centerUnitOffsetX;
    
    CGRect overlayCellUnitDefaultFrame;

}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DjuPickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.allowsSelection = NO;
		_tableView.showsVerticalScrollIndicator = NO;
		_tableView.showsHorizontalScrollIndicator = NO;
					
		self.overlayCell = [[UIView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.frame.size.width, 40.0)];
		self.overlayCell.backgroundColor = [UIColor clearColor];
		self.overlayCell.userInteractionEnabled = NO;
//		self.overlayCell.alpha = 0.25;
        
        selectedLineHeight = 0.3;
        
        self.overlayCellUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 100, 14)];
        self.overlayCellUnit.backgroundColor = [UIColor clearColor];
        self.overlayCellUnit.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.overlayCell addSubview:self.overlayCellUnit];
        
        overlayCellUnitDefaultFrame  = self.overlayCellUnit.frame;
        
        _selectedRow = 0;
        centerUnitOffsetX = 0;
        _overlayCellUnitXAdditionalOffset = 0;
        
        
        [self addSubview:_tableView];
        [self addSubview:self.overlayCell];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (!_tableView.superview)
    {
//        [self addSubview:_tableView];
    }
    
    if (!_overlayCell.superview)
    {
//        [self addSubview:self.overlayCell];
    }
    
    [self adjustFrame];
}

- (void)adjustFrame
{
    _tableView.frame = self.bounds;
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
    // Move overlay to center of table view
    CGFloat centerY = (self.frame.size.height - rowHeight) / 2.0;
    self.overlayCell.frame = CGRectMake(0.0, centerY, self.frame.size.width, rowHeight);
    UIView *bottomLineV = [self.overlayCell viewWithTag:2];
    bottomLineV.frame = CGRectMake(0, rowHeight - selectedLineHeight, self.frame.size.width, selectedLineHeight);
    
    
    // Calculate height of table based on height of cell and height of frame
    // Figure out the number of cells that will fit on the table
    //NSInteger numCells = (NSInteger)(floor(self.frame.size.height / [self.delegate rowHeightForDjuPickerView:self]));
    
    [self layoutOverlayCellUnitView];
    
    [_tableView reloadData];
    
    CGRect rect = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
    CGFloat offsetY;
    if (_selectedRow == 0)
    {
        offsetY = 0;
    }
    else
    {
        offsetY = rect.origin.y - self.overlayCell.frame.origin.y;
        
        NSLog(@"%s why? %f", __PRETTY_FUNCTION__, offsetY / rowHeight);
    }
    [_tableView setContentOffset:CGPointMake(0.0, offsetY)];
}

- (void)layoutOverlayCellUnitView
{
    CGRect defaultFrame = overlayCellUnitDefaultFrame;
    CGRect unitFrame = self.overlayCellUnit.frame;
    unitFrame.origin.x = CGRectGetWidth(self.frame) / 2 + MAX(centerUnitOffsetX + 10.0f, 29) + _overlayCellUnitXAdditionalOffset;
    unitFrame.origin.y = defaultFrame.origin.y + self.overlayCellUnitYAdditionalOffset;
    self.overlayCellUnit.frame = unitFrame;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	// Always pass all touches on this view to the table view
	return _tableView;
}

- (void)selectRow:(NSInteger)row
{
    [self selectRow:row animated:NO];
}

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
    CGFloat offsetY = row * rowHeight;
    
//    CGRect rect = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//    offsetY = self.overlayCell.frame.origin.y - rect.origin.y;
    
    [_tableView setContentOffset:CGPointMake(0.0, offsetY) animated:animated];
    
    _selectedRow = row;
    [_tableView reloadData];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _tableView.backgroundColor = backgroundColor;
}

#pragma mark - UITableViewDelegate functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource numberOfRowsInDjuPickerView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	static NSString *CellIdentifier = @"DjuPickerViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
	if (cell == nil) {
		// Alloc a new cell
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
		UIView *contentView = cell.contentView;
        contentView.backgroundColor = [UIColor clearColor];
				
		UILabel *textLabel;
		if (indexPath.row == 0) {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight)];
		} else {
			textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight)];
		}
		textLabel.tag = -1;
		textLabel.text = [self.delegate djuPickerView:self titleForRow:indexPath.row];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentCenter;

        [self changeTitleLabelColor:textLabel ForIndexPath:indexPath];
        
        if (centerUnitOffsetX == 0)
        {
            CGSize size = [textLabel sizeThatFits:CGSizeMake(self.frame.size.width, rowHeight)];
            centerUnitOffsetX = size.width / 2.0f;
            [self layoutOverlayCellUnitView];
        }
        
		[contentView addSubview:textLabel];
		
	} else {
		// Reuse cell
		UIView *contentView = cell.contentView;
				
		UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
		textLabel.text = [self.delegate djuPickerView:self titleForRow:indexPath.row];
		[self changeTitleLabelColor:textLabel ForIndexPath:indexPath];
        
		if (indexPath.row == 0) {
			textLabel.frame = CGRectMake(0.0, self.overlayCell.frame.origin.y, self.frame.size.width, rowHeight);
		} else {
			textLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, rowHeight);
		}
	}
    
    if ([self.delegate respondsToSelector:@selector(djuPickerView:attributedTitleForRow:selectedRow:)]) {
        
        NSAttributedString *attributedString = [self.delegate djuPickerView:self attributedTitleForRow:indexPath.row selectedRow:self.selectedRow];
        
        if (attributedString) {
            UIView *contentView = cell.contentView;
            
            UILabel *textLabel = (UILabel*)[contentView viewWithTag:-1];
            textLabel.attributedText = attributedString;
        }
        
        
    }
		
	return cell;
}

- (void)changeTitleLabelColor:(UILabel *)label ForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == _selectedRow)
    {
        [self.delegate labelSelectedStyleForDjuPickerView:self forLabel:label];
        label.alpha = 1;
    }
    else if (ABS(row - _selectedRow) <= 1)
    {
        [self.delegate labelStyleForDjuPickerView:self forLabel:label];
        label.alpha = 1;
    }
    else
    {
        [self.delegate labelStyleForDjuPickerView:self forLabel:label];
        label.alpha = 0.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	// Add front and back padding to make this more closely resemble a picker view
	if (indexPath.row == 0) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	} else if (indexPath.row == [self.dataSource numberOfRowsInDjuPickerView:self] - 1) {
		return (self.overlayCell.frame.origin.y + rowHeight);
	}
	return rowHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"offsetY: %f", scrollView.contentOffset.y);;
    
    if (scrollView.isDragging)
    {
        CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        CGFloat floatVal = offsetY / rowHeight;
        
        NSInteger selectedRow = (NSInteger)(lround(floatVal));
        
        if (selectedRow != _selectedRow) {
            // Tell delegate where we're scrolling to
            _selectedRow = selectedRow;

            if ([self.delegate respondsToSelector:@selector(djuPickerView:didScrollToRow:)]) {
                [self.delegate djuPickerView:self didScrollToRow:_selectedRow];
                
            }
        }
        
        [_tableView reloadData];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat rowHeight = [self.delegate rowHeightForDjuPickerView:self];
    
	// Auto scroll to next multiple of rowHeight
	CGFloat floatVal = targetContentOffset->y / rowHeight;
	NSInteger rounded = (NSInteger)(lround(floatVal));

	targetContentOffset->y = rounded * rowHeight;
    
    // Tell delegate where we're landing
    [self.delegate djuPickerView:self didSelectRow:rounded];
    
    _selectedRow = rounded;
    
    [_tableView reloadData];
}

@end
