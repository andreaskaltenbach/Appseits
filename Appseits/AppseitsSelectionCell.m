//
//  AppseitsSelectionCellCell.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsSelectionCell.h"
#import "UIColor+AppColors.h"

static UIImage *unselectedImage;
static UIImage *selectedImage;

@interface AppseitsSelectionCell()
@property (nonatomic, strong) UIView *background;
@end

@implementation AppseitsSelectionCell

@synthesize background = _background;

+ (void) initialize {
    unselectedImage = [UIImage imageNamed:@"itemUnselected"];
    selectedImage = [UIImage imageNamed:@"itemSelected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.background = [[UIView alloc] init];
        self.background.frame = CGRectMake(10, 5, 300, 43);
        [self addSubview:self.background];
        [self sendSubviewToBack:self.background];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.background.backgroundColor = [UIColor colorWithPatternImage:selectedImage];
    }
    else {
        self.background.backgroundColor = [UIColor colorWithPatternImage:unselectedImage];
    }
}

@end
