//
//  CompetitorStatisticCell.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompetitorStatisticCell.h"

static UIImage* grayBackground;

@interface CompetitorStatisticCell() 
    
@property (nonatomic, strong) UIImageView* grayBackground;
@end;

@implementation CompetitorStatisticCell

@synthesize points = _points;
@synthesize flag = _flag;
@synthesize name = _name;
@synthesize grayBackground = _grayBackground;

+ (void) initialize {
    grayBackground = [UIImage imageNamed:@"grayCellBackground"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.flag = (UIImageView*) [self viewWithTag:1];
        self.name = (UILabel*) [self viewWithTag:2];
        self.points = (UILabel*) [self viewWithTag:3];
        self.grayBackground = (UIImageView*) [self viewWithTag:99];
        self.grayBackground.image = grayBackground;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setOdd:(BOOL) odd {
    self.grayBackground.hidden = odd;
}

@end
