//
//  GameResultCelll.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameResultCelll.h"
#import "UIColor+AppColors.h"

@interface GameResultCelll()
@property (nonatomic, strong) UILabel *firstTeamGoals;
@property (nonatomic, strong) UILabel *secondTeamGoals;
@end

@implementation GameResultCelll

@synthesize game = _game;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize secondTeamGoals = _secondTeamGoals;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
                
        self.firstTeamGoals = (UILabel*) [self viewWithTag:15];
        self.secondTeamGoals = (UILabel*) [self viewWithTag:25];        
        
    }
    return self;
}

- (void) setGame:(Game *)game {
    [super setGame:game];
    
    self.firstTeamGoals.text = [NSString stringWithFormat:@"%i", game.firstTeamGoals];
    self.secondTeamGoals.text = [NSString stringWithFormat:@"%i", game.secondTeamGoals];
}

@end
