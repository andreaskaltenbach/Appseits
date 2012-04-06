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
@property (nonatomic, strong) SSGradientView *firstTeamPredictionGradient;
@property (nonatomic, strong) SSGradientView *secondTeamPredictionGradient;
@property (nonatomic, strong) UILabel *firstTeamPrediction;
@property (nonatomic, strong) UILabel *secondTeamPrediction;
@property (nonatomic, strong) UIImageView *pointsBackground;
@property (nonatomic, strong) UILabel *pointsLabel;
@end

@implementation GameResultCelll

@synthesize game = _game;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize firstTeamPredictionGradient = _firstTeamPredictionGradient;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize secondTeamPredictionGradient = _secondTeamPredictionGradient;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize pointsBackground = _pointsBackground;
@synthesize pointsLabel = _pointsLabel;

+ (void) initialize {
    greenBall = [UIImage imageNamed:@"greenBall"];
    grayBall = [UIImage imageNamed:@"grayBall"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstTeamGoals = (UILabel*) [self viewWithTag:15];
        self.firstTeamPredictionGradient = (SSGradientView*) [self viewWithTag:16];
        self.firstTeamPrediction = (UILabel*) [self viewWithTag:17];
        
        self.secondTeamGoals = (UILabel*) [self viewWithTag:25];        
        self.secondTeamPredictionGradient = (SSGradientView*) [self viewWithTag:26];
        self.secondTeamPrediction = (UILabel*) [self viewWithTag:27];
        
        self.pointsBackground = (UIImageView*) [self viewWithTag:30];
        self.pointsLabel = (UILabel*) [self viewWithTag:31];
    }
    return self;
}

- (void) setGame:(Game *)game {
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
        self.firstTeamPredictionGradient.colors = [UIColor grayGradient];
        self.secondTeamPredictionGradient.colors = [UIColor grayGradient];
    }
    else if (game.firstTeamGoals == game.firstTeamPrediction
        && game.secondTeamGoals == game.secondTeamPrediction) {
        // the player did bet the exact result
        self.firstTeamPredictionGradient.colors = [UIColor greenGradient];
        self.secondTeamPredictionGradient.colors = [UIColor greenGradient];
    }
    else if (game.firstTeamGoals.intValue - game.secondTeamGoals.intValue
        == game.firstTeamPrediction.intValue - game.secondTeamPrediction.intValue) {
        // the player did bet on the correct goal difference
        self.firstTeamPredictionGradient.colors = [UIColor greenGradient];
        self.secondTeamPredictionGradient.colors = [UIColor greenGradient];
    }
    else if (game.firstTeamGoals > game.secondTeamGoals &&
             game.firstTeamPrediction > game.secondTeamPrediction) {
        // first team did win and player betted on that
        self.firstTeamPredictionGradient.colors = [UIColor greenGradient];
        self.secondTeamPredictionGradient.colors = [UIColor grayGradient];
    }
    else if (game.firstTeamGoals < game.secondTeamGoals &&
             game.firstTeamPrediction < game.secondTeamPrediction) {
        // first team did win and player betted on that
        self.firstTeamPredictionGradient.colors = [UIColor grayGradient];
        self.secondTeamPredictionGradient.colors = [UIColor greenGradient];
    }
    else {
        // the bet was not correct at all
        self.firstTeamPredictionGradient.colors = [UIColor grayGradient];
        self.secondTeamPredictionGradient.colors = [UIColor grayGradient];
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
