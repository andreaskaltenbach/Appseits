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
static UIImage *greenBallCheck;


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
    greenBallCheck = [UIImage imageNamed:@"greenBallCheck"];
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
        self.pointsLabel.backgroundColor = [UIColor clearColor];
        
        self.matchLock = (UIImageView*) [self viewWithTag:33];
        self.matchLock.image = matchLock;
        
        self.leftPointsBackground = (UIView*) [self viewWithTag:180];
        self.firstTeamPrediction = (UILabel*) [self viewWithTag:181];
        
        self.rightPointsBackground = (UIView*) [self viewWithTag:280];
        self.secondTeamPrediction = (UILabel*) [self viewWithTag:281];
    }
    return self;
}

- (void) setMatch:(Match *)match {
    [super setMatch:match];

    // set match result
    if (match.firstTeamGoals) {
        self.firstTeamGoals.text = [NSString stringWithFormat:@"%i", match.firstTeamGoals.intValue];
    }
    else {
        self.firstTeamGoals.text = @"-";
    }
    
    if (match.secondTeamGoals) {
        self.secondTeamGoals.text = [NSString stringWithFormat:@"%i", match.secondTeamGoals.intValue];
    }
    else {
        self.secondTeamGoals.text = @"-";
    }
    
    // set predictions
    if (match.firstTeamPrediction) {
        self.firstTeamPrediction.text = [NSString stringWithFormat:@"%i", match.firstTeamPrediction.intValue];
    }
    else {
        self.firstTeamPrediction.text = @"-";
    }
    
    if (match.secondTeamPrediction) {
        self.secondTeamPrediction.text = [NSString stringWithFormat:@"%i", match.secondTeamPrediction.intValue];
    }
    else {
        self.secondTeamPrediction.text = @"-";
    }
    
    // highlight predictions
    if (!match.firstTeamGoals && !match.secondTeamGoals) {
        [self switchLeftPrediction:NO];
        [self switchRightPrediction:NO];
    }
    else if (match.firstTeamPrediction.intValue == match.firstTeamGoals.intValue
        && match.secondTeamPrediction.intValue == match.secondTeamGoals.intValue) {
        // correct result predicted -> show both green boxes:
        [self switchLeftPrediction:YES];
        [self switchRightPrediction:YES];
    }
    else {
        int resultDiff = match.firstTeamGoals.intValue - match.secondTeamGoals.intValue;
        int predictionDiff = match.firstTeamPrediction.intValue - match.secondTeamPrediction.intValue;
        
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
    if (!match.firstTeamGoals && !match.secondTeamGoals) {
        if (!match.firstTeamPrediction && !match.secondTeamPrediction) {
            // game is not yet played and no predictions are made
            self.pointsBackground.hidden = YES;
            self.pointsLabel.hidden = YES;
        }
        else {
            // match is not yet played and but predictions are made
            self.pointsBackground.hidden = NO;
            self.pointsBackground.image = greenBallCheck;
            self.pointsLabel.hidden = YES;
        }
    }
    else {
        if (match.points > 0) {
            // match is played and user got points
            self.pointsBackground.hidden = NO;
            self.pointsBackground.image = greenBall;
            self.pointsLabel.hidden = NO;
            self.pointsLabel.text = [NSString stringWithFormat:@"%ip", match.points.intValue];
            self.pointsLabel.opaque = 1;
        }
        else {
            // match is played and user got 0 points
            self.pointsBackground.hidden = NO;
            self.pointsBackground.image = grayBall;
            self.pointsLabel.hidden = NO;
            self.pointsLabel.text = @"0p";
            self.pointsLabel.opaque = 0.4;
        }
    }
    
    // show or hide lock
    self.matchLock.hidden = self.match.matchRound.notPassed;
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
