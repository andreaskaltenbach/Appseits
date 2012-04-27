//
//  GameResultCelll.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameResultCelll.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"
#import <QuartzCore/QuartzCore.h>

static UIImage *greenBall;
static UIImage *grayBall;

@interface GameResultCelll()
@property (nonatomic, strong) UILabel *firstTeamGoals;
@property (nonatomic, strong) UILabel *secondTeamGoals;
@property (nonatomic, strong) UILabel *firstTeamPrediction;
@property (nonatomic, strong) UILabel *secondTeamPrediction;
@property (nonatomic, strong) UIImageView *pointsBackground;
@property (nonatomic, strong) UILabel *pointsLabel;
@property (nonatomic, strong) UIView *leftPointsBackground;
@property (nonatomic, strong) UIView *rightPointsBackground;
@property (nonatomic, strong) UIImageView *matchLock;

@end

@implementation GameResultCelll

@synthesize game = _game;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize pointsBackground = _pointsBackground;
@synthesize pointsLabel = _pointsLabel;
@synthesize leftPointsBackground = _leftPointsBackground;
@synthesize rightPointsBackground = _rightPointsBackground;
@synthesize matchLock = _matchLock;

static UIColor* pointsBackground;
static UIImage* matchLock;

+ (void) initialize {
    greenBall = [UIImage imageNamed:@"greenBall"];
    grayBall = [UIImage imageNamed:@"grayBall"];
    pointsBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pointsBackgroundGreen"]];
    matchLock = [UIImage imageNamed:@"matchLock"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstTeamGoals = (UILabel*) [self viewWithTag:15];
        self.firstTeamPrediction = (UILabel*) [self viewWithTag:17];
        
        self.secondTeamGoals = (UILabel*) [self viewWithTag:25];        
        self.secondTeamPrediction = (UILabel*) [self viewWithTag:27];
        
        self.pointsBackground = (UIImageView*) [self viewWithTag:30];
        self.pointsLabel = (UILabel*) [self viewWithTag:31];
        
        self.matchLock = (UIImageView*) [self viewWithTag:33];
        self.matchLock.image = matchLock;
        
        self.leftPointsBackground = (UIView*) [self viewWithTag:180];
        self.rightPointsBackground = (UIView*) [self viewWithTag:280];
    }
    return self;
}

- (void) setGame:(Match *)game {
    [super setGame:game];

    // set match result
    if (game.firstTeamGoals && game.secondTeamGoals) {
        self.firstTeamGoals.text = [NSString stringWithFormat:@"%i", game.firstTeamGoals.intValue];
        self.secondTeamGoals.text = [NSString stringWithFormat:@"%i", game.secondTeamGoals.intValue];
    } else {
        self.firstTeamGoals.text = @"-";
        self.secondTeamGoals.text = @"-";
    }
    
    if (!game.firstTeamPrediction || !game.secondTeamPrediction) {
        // player does not set any prediction:
        self.leftPointsBackground.backgroundColor = [UIColor clearColor];
        self.rightPointsBackground.backgroundColor = pointsBackground;
    }
    else if (game.firstTeamGoals == game.firstTeamPrediction
        && game.secondTeamGoals == game.secondTeamPrediction) {
        // the player did bet the exact result
        self.leftPointsBackground.backgroundColor = pointsBackground;
        self.rightPointsBackground.backgroundColor = pointsBackground;
    }
    else if (game.firstTeamGoals.intValue - game.secondTeamGoals.intValue
        == game.firstTeamPrediction.intValue - game.secondTeamPrediction.intValue) {
        // the player did bet on the correct goal difference
        self.leftPointsBackground.backgroundColor = pointsBackground;
        self.rightPointsBackground.backgroundColor = pointsBackground;
    }
    else if (game.firstTeamGoals > game.secondTeamGoals &&
             game.firstTeamPrediction > game.secondTeamPrediction) {
        // first team did win and player betted on that
        self.leftPointsBackground.backgroundColor = pointsBackground;
        self.rightPointsBackground.backgroundColor = [UIColor clearColor];
    }
    else if (game.firstTeamGoals < game.secondTeamGoals &&
             game.firstTeamPrediction < game.secondTeamPrediction) {
        // first team did win and player betted on that
        self.leftPointsBackground.backgroundColor = pointsBackground;
        self.rightPointsBackground.backgroundColor = [UIColor clearColor];
    }
    else {
        // the bet was not correct at all
        self.leftPointsBackground.backgroundColor = [UIColor clearColor];
        self.rightPointsBackground.backgroundColor = [UIColor clearColor];
    }
    
    // set the user's predictions
    if (game.firstTeamPrediction && game.secondTeamPrediction) {
        self.firstTeamPrediction.text = [NSString stringWithFormat:@"%i", game.firstTeamPrediction.intValue];
        self.secondTeamPrediction.text = [NSString stringWithFormat:@"%i", game.secondTeamPrediction.intValue];
    }    
    else {
        self.firstTeamPrediction.text = @"-";
        self.secondTeamPrediction.text = @"-";
    }
    
    if (game.points.intValue > 0) {
        self.pointsBackground.image = greenBall;
        self.pointsLabel.text = [NSString stringWithFormat:@"%i",game.points.intValue];
    } else {
        self.pointsBackground.image = grayBall;
        self.pointsLabel.text = [NSString stringWithFormat:@"%i",0];
    }
}

@end
