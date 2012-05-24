//
//  GameResultCelll.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchResultCell.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"
#import <QuartzCore/QuartzCore.h>

static UIImage *greenBall;
static UIImage *grayBall;

@interface MatchResultCell()
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

@implementation MatchResultCell

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

static UIImage *resultBackgroundImage;
static UIImage *resultSelectedBackgroundImage;

+ (void) initialize {
    greenBall = [UIImage imageNamed:@"greenBall"];
    grayBall = [UIImage imageNamed:@"grayBall"];
    pointsBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pointsBackgroundGreen"]];
    matchLock = [UIImage imageNamed:@"matchLock"];
    
    resultBackgroundImage = [UIImage imageNamed:@"matchResultCell"];
    resultSelectedBackgroundImage = [UIImage imageNamed:@"matchResultCellSelected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.firstTeamGoals = (UILabel*) [self viewWithTag:15];
        self.secondTeamGoals = (UILabel*) [self viewWithTag:25];        
        
        self.pointsBackground = (UIImageView*) [self viewWithTag:30];
        self.pointsLabel = (UILabel*) [self viewWithTag:31];
        
        self.matchLock = (UIImageView*) [self viewWithTag:33];
        self.matchLock.image = matchLock;
        
        self.leftPointsBackground = (UIView*) [self viewWithTag:180];
        self.firstTeamPrediction = (UILabel*) [self viewWithTag:181];
        
        self.rightPointsBackground = (UIView*) [self viewWithTag:280];
        self.secondTeamPrediction = (UILabel*) [self viewWithTag:281];
    }
    return self;
}

- (void) setMatch:(Match *)game {
    [super setMatch:game];

    // set match result
    if (game.firstTeamGoals) {
        self.firstTeamGoals.text = [NSString stringWithFormat:@"%i", game.firstTeamGoals.intValue];
    }
    else {
        self.firstTeamGoals.text = @"-";
    }
    
    if (game.secondTeamGoals) {
        self.secondTeamGoals.text = [NSString stringWithFormat:@"%i", game.secondTeamGoals.intValue];
    }
    else {
        self.secondTeamGoals.text = @"-";
    }
    
    // set predictions
    if (game.firstTeamPrediction) {
        self.firstTeamPrediction.text = [NSString stringWithFormat:@"%i", game.firstTeamPrediction.intValue];
    }
    else {
        self.firstTeamPrediction.text = @"-";
    }
    
    if (game.secondTeamPrediction) {
        self.secondTeamPrediction.text = [NSString stringWithFormat:@"%i", game.secondTeamPrediction.intValue];
    }
    else {
        self.secondTeamPrediction.text = @"-";
    }
    
    // highlight predictions
    if (!game.firstTeamGoals && !game.secondTeamGoals) {
        [self switchLeftPrediction:NO];
        [self switchRightPrediction:NO];
    }
    else if (game.firstTeamPrediction.intValue == game.firstTeamGoals.intValue
        && game.secondTeamPrediction.intValue == game.secondTeamGoals.intValue) {
        // correct result predicted -> show both green boxes:
        [self switchLeftPrediction:YES];
        [self switchRightPrediction:YES];
    }
    else {
        int resultDiff = game.firstTeamGoals.intValue - game.secondTeamGoals.intValue;
        int predictionDiff = game.firstTeamPrediction.intValue - game.secondTeamPrediction.intValue;
        
        if (resultDiff == 0 && predictionDiff == 0) {
          // X was predicted correctly
            [self switchLeftPrediction:YES];
            [self switchRightPrediction:YES]; 
            
        } else if (resultDiff * predictionDiff > 0) {
            // 1 or 2 was predicted correctly
            
            if (resultDiff > 0) {
                [self switchLeftPrediction:YES];
                [self switchRightPrediction:NO]; 
            }
            else {
                [self switchLeftPrediction:NO];
                [self switchRightPrediction:YES];
            }
        } else {
            [self switchLeftPrediction:NO];
            [self switchRightPrediction:NO];
        }
    }
    
    // change ball
    if (!game.firstTeamGoals && !game.secondTeamGoals) {
        // game is not yet played
        if (game.firstTeamPrediction && game.secondTeamPrediction) {
            self.pointsBackground.hidden = YES;
        }
        else {
            self.pointsBackground.hidden = NO;
            // TODO - replace with check image
        }
    }
}

- (void) switchLeftPrediction:(BOOL) userGetsPoints {
    if (userGetsPoints) {
        self.leftPointsBackground.backgroundColor = pointsBackground;
        self.firstTeamPrediction.textColor = [UIColor whiteColor];
    }
    else {
        self.leftPointsBackground.backgroundColor = [UIColor clearColor];
        self.firstTeamPrediction.textColor = [UIColor transparentWhite];
    }
}
- (void) switchRightPrediction:(BOOL) userGetsPoints {
    if (userGetsPoints) {
        self.rightPointsBackground.backgroundColor = pointsBackground;
        self.secondTeamPrediction.textColor = [UIColor whiteColor];
    }
    else {
        self.rightPointsBackground.backgroundColor = [UIColor clearColor];
        self.secondTeamPrediction.textColor = [UIColor transparentWhite];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithPatternImage:resultSelectedBackgroundImage];
    }
    else {
        self.backgroundColor = [UIColor colorWithPatternImage:resultBackgroundImage];
    }
}

@end
