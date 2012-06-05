//
//  CompetitorStatisticCell.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompetitorStatisticCell.h"

@implementation CompetitorStatisticCell

@synthesize points = _points;
@synthesize flag = _flag;
@synthesize name = _name;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.flag = (UIImageView*) [self viewWithTag:1];
        self.name = (UILabel*) [self viewWithTag:2];
        self.points = (UILabel*) [self viewWithTag:3];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
