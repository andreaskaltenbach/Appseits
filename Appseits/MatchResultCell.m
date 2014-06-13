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
#import "MatchResultUtil.h"


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

static UIImage* matchLock;

static UIImage *resultBackgroundImage;
static UIImage *resultSelectedBackgroundImage;


+ (void) initialize {
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
    
    MatchResultUtil* matchResultUtil = [MatchResultUtil utilForPredictions:match.firstTeamPrediction :match.secondTeamPrediction forMatchResult:match.firstTeamGoals :match.secondTeamGoals withPoints:match.points];
    
    // highlight predictions
    [matchResultUtil switchLeftPredictionBackground:self.leftPointsBackground];
    [matchResultUtil switchRightPredictionBackground:self.rightPointsBackground];
    
    [matchResultUtil updateLeftPredictionLabel:self.firstTeamPrediction];
    [matchResultUtil updateRightPredictionLabel:self.secondTeamPrediction];
    
    [matchResultUtil updatePointsBall:self.pointsBackground :self.pointsLabel];
        
    // show or hide lock
    self.matchLock.hidden = self.match.matchRound.notPassed;
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
