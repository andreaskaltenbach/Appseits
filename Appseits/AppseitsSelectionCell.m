//
//  AppseitsSelectionCellCell.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsSelectionCell.h"
#import "SSGradientView.h"
#import "UIColor+AppColors.h"

static UIImage *unselectedImage;

@interface AppseitsSelectionCell()
@property (nonatomic, strong) UIView *background;
@end

@implementation AppseitsSelectionCell

@synthesize background = _background;

+ (void) initialize {
    unselectedImage = [UIImage imageNamed:@"unselectedBackground"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.background = [[UIView alloc] initWithFrame:self.bounds];
        self.background.backgroundColor = [UIColor colorWithPatternImage:unselectedImage];
        [self addSubview:self.background];
        [self sendSubviewToBack:self.background];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
//        self.backgroundGradient.colors = [UIColor greenGradient];
    }
    else {
  //      self.backgroundGradient.colors = [UIColor grayGradient];
    }
}

@end
