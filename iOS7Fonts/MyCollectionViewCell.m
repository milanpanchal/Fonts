//
//  MyCollectionViewCell.m
//  MyCollectionViewExample
//
//  Created by Milan Kumar Panchal on 04/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    
    self.unicode.backgroundColor = [UIColor clearColor];
    self.hexString.backgroundColor = [UIColor clearColor];
    self.unicode.textAlignment = NSTextAlignmentCenter;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
