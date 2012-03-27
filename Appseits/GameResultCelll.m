//
//  GameResultCelll.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameResultCelll.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColors.h"


@interface GameResultCelll()
@property (nonatomic, strong) UILabel *firstTeamName;
@property (nonatomic, strong) UILabel *secondTeamName;
@end

@implementation GameResultCelll

@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;

@synthesize game = _game;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [UIColor gameCellGradient];
        [self.layer insertSublayer:gradient atIndex:0];
        
        self.firstTeamName = (UILabel*) [self viewWithTag:20];
        self.secondTeamName = (UILabel*) [self viewWithTag:21];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setGame:(Game *)game {
    _game = game;
    
    self.firstTeamName.text = game.firstTeamName;
    self.secondTeamName.text = game.secondTeamName;
}

@end
