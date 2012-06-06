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
    
@property (nonatomic, strong) UIView* grayBackground;
@end;

@implementation CompetitorStatisticCell

@synthesize points = _points;
@synthesize flag = _flag;
@synthesize name = _name;
@synthesize grayBackground = _grayBackground;

+ (void) initialize {
    grayBackground = [UIImage imageNamed:@"greyCellBackground"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.flag = (UIImageView*) [self viewWithTag:1];
        self.name = (UILabel*) [self viewWithTag:2];
        self.points = (UILabel*) [self viewWithTag:3];
        self.grayBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        self.grayBackground.backgroundColor = [UIColor colorWithPatternImage:grayBackground];
        [self addSubview:self.grayBackground];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setOdd:(BOOL) odd {
    self.grayBackground.hidden = !odd;
}

@end
