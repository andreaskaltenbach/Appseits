//
//  ComparisonCell.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComparisonCell.h"
#import "MatchResultUtil.h"
#import "UIColor+AppColors.h"

@interface ComparisonCell()
@property (nonatomic, strong) UILabel* firstTeamNameLabel;
@property (nonatomic, strong) UILabel* firstTeamPointsLabel;
@property (nonatomic, strong) UILabel* secondTeamNameLabel;
@property (nonatomic, strong) UILabel* secondTeamPointsLabel;
@property (nonatomic, strong) UIImageView* firstTeamFlag;
@property (nonatomic, strong) UIImageView* secondTeamFlag;

@property (nonatomic, strong) UILabel* myInitials;
@property (nonatomic, strong) UILabel* competitorInitials;

@property (nonatomic, strong) UILabel* myFirstTeamPredictionLabel;
@property (nonatomic, strong) UILabel* mySecondTeamPredictionLabel;
@property (nonatomic, strong) UILabel* myScoreLabel;
@property (nonatomic, strong) UILabel* competitorFirstTeamPredictionLabel;
@property (nonatomic, strong) UILabel* competitorSecondTeamPredictionLabel;
@property (nonatomic, strong) UIView* competitorFirstPredictionBackground;
@property (nonatomic, strong) UIView* competitorSecondPredictionBackground;

@property (nonatomic, strong) UIView* myFirstPredictionBackground;
@property (nonatomic, strong) UIView* mySecondPredictionBackground;

@property (nonatomic, strong) UILabel* competitorScoreLabel;
@property (nonatomic, strong) UIImageView* competitorPointBall;
@property (nonatomic, strong) UIImageView* myPointBall;

@property (nonatomic, strong) UIView* nextMatchBar;

@end

@implementation ComparisonCell
@synthesize firstTeamNameLabel = _firstTeamNameLabel;
@synthesize firstTeamPointsLabel = _firstTeamPointsLabel;
@synthesize secondTeamNameLabel = _secondTeamNameLabel;
@synthesize secondTeamPointsLabel = _secondTeamPointsLabel;
@synthesize firstTeamFlag = _firstTeamFlag;
@synthesize secondTeamFlag = _secondTeamFlag;

@synthesize myInitials = _myInitials;
@synthesize competitorInitials = _competitorInitials;

@synthesize myFirstTeamPredictionLabel = _myFirstTeamPredictionLabel;
@synthesize mySecondTeamPredictionLabel = _mySecondTeamPredictionLabel;
@synthesize myScoreLabel = _myScoreLabel;
@synthesize competitorFirstTeamPredictionLabel = _competitorFirstTeamPredictionLabel;
@synthesize competitorSecondTeamPredictionLabel = _competitorSecondTeamPredictionLabel;
@synthesize competitorScoreLabel = _competitorScoreLabel;

@synthesize competitorFirstPredictionBackground = _competitorFirstPredictionBackground;
@synthesize competitorSecondPredictionBackground = _competitorSecondPredictionBackground;

@synthesize myFirstPredictionBackground = _myFirstPredictionBackground;
@synthesize mySecondPredictionBackground = _mySecondPredictionBackground;

@synthesize competitorPointBall = _competitorPointBall;
@synthesize myPointBall = _myPointBall;

@synthesize nextMatchBar = _nextMatchBar;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.firstTeamNameLabel = (UILabel*) [self viewWithTag:11];
        self.firstTeamFlag = (UIImageView*) [self viewWithTag:12];
        self.firstTeamPointsLabel = (UILabel*) [self viewWithTag:13];
        
        self.secondTeamNameLabel = (UILabel*) [self viewWithTag:21];
        self.secondTeamFlag = (UIImageView*) [self viewWithTag:22];
        self.secondTeamPointsLabel = (UILabel*) [self viewWithTag:23];
        
        self.myInitials = (UILabel*) [self viewWithTag:32];
        self.competitorInitials = (UILabel*) [self viewWithTag:31];
        
        self.myFirstTeamPredictionLabel = (UILabel*) [self viewWithTag:35];
        self.mySecondTeamPredictionLabel = (UILabel*) [self viewWithTag:36];
        
        self.competitorFirstTeamPredictionLabel = (UILabel*) [self viewWithTag:33];
        self.competitorSecondTeamPredictionLabel = (UILabel*) [self viewWithTag:34];

        self.myScoreLabel = (UILabel*) [self viewWithTag:38];
        self.competitorScoreLabel = (UILabel*) [self viewWithTag:37];
        
        self.competitorFirstPredictionBackground = (UIView*) [self viewWithTag:111];
        self.competitorSecondPredictionBackground = (UIView*) [self viewWithTag:222];
        
        self.myFirstPredictionBackground = (UIView*) [self viewWithTag:133];
        self.mySecondPredictionBackground = (UIView*) [self viewWithTag:233];
        
        self.competitorPointBall = (UIImageView*) [self viewWithTag:333];
        self.myPointBall = (UIImageView*) [self viewWithTag:444];
        
        self.nextMatchBar = (UIView*) [self viewWithTag:456];
        self.nextMatchBar.backgroundColor = [UIColor nextMatchColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMatchComparison:(MatchComparison *)matchComparison {
    
    self.firstTeamNameLabel.text = [matchComparison.match.firstTeam.shortName uppercaseString];
    self.secondTeamNameLabel.text = [matchComparison.match.secondTeam.shortName uppercaseString];
    
    self.firstTeamFlag.image = matchComparison.match.firstTeam.flag;
    self.secondTeamFlag.image = matchComparison.match.secondTeam.flag;
    
    if (matchComparison.match.firstTeamGoals) {
        self.firstTeamPointsLabel.text = [NSString stringWithFormat:@"%i", matchComparison.match.firstTeamGoals.intValue];
    }
    else {
        self.firstTeamPointsLabel.text = @"-";
    }
    
    if (matchComparison.match.secondTeamGoals) {
        self.secondTeamPointsLabel.text = [NSString stringWithFormat:@"%i", matchComparison.match.secondTeamGoals.intValue];
    }
    else {
        self.secondTeamPointsLabel.text = @"-";
    }
    
    self.myFirstTeamPredictionLabel.text = [NSString stringWithFormat:@"%i", matchComparison.myPredictionFirstTeam.intValue];
    self.mySecondTeamPredictionLabel.text = [NSString stringWithFormat:@"%i", matchComparison.myPredictionSecondTeam.intValue];

    self.competitorFirstTeamPredictionLabel.text = [NSString stringWithFormat:@"%i", matchComparison.competitorPredictionFirstTeam.intValue];
    self.competitorSecondTeamPredictionLabel.text = [NSString stringWithFormat:@"%i", matchComparison.competitorPredictionSecondTeam.intValue];
    
    self.myInitials.text = matchComparison.roundComparison.comparison.myInitials;
    self.competitorInitials.text = matchComparison.roundComparison.comparison.competitorInitials;
    
    self.myScoreLabel.text = [NSString stringWithFormat:@"%ip", matchComparison.myPredictionScore.intValue];
    self.competitorScoreLabel.text = [NSString stringWithFormat:@"%ip", matchComparison.competitorScore.intValue];
    
    // update prediction labels for competitor:
    MatchResultUtil* competitorResultUtil = [MatchResultUtil utilForPredictions:matchComparison.competitorPredictionFirstTeam :matchComparison.competitorPredictionSecondTeam forMatchResult:matchComparison.match.firstTeamGoals :matchComparison.match.secondTeamGoals withPoints:matchComparison.competitorScore];
    
    [competitorResultUtil updateLeftPredictionLabel:self.competitorFirstTeamPredictionLabel];
    [competitorResultUtil updateRightPredictionLabel:self.competitorSecondTeamPredictionLabel];
    
    [competitorResultUtil switchLeftPredictionBackground:self.competitorFirstPredictionBackground];
    [competitorResultUtil switchRightPredictionBackground:self.competitorSecondPredictionBackground];
    [competitorResultUtil updatePointsBall:self.competitorPointBall :self.competitorScoreLabel];
    
    // hide balls, if match is not yet played:
    if (!matchComparison.match.firstTeamGoals && !matchComparison.match.secondTeamGoals) {
        self.competitorPointBall.image = nil;
        self.myPointBall.image = nil;
    }
    
    // update own prediction labels:
    MatchResultUtil* myResultUtil = [MatchResultUtil utilForPredictions:matchComparison.myPredictionFirstTeam :matchComparison.myPredictionSecondTeam forMatchResult:matchComparison.match.firstTeamGoals :matchComparison.match.secondTeamGoals withPoints:matchComparison.myPredictionScore];
    
    [myResultUtil updatePointsBall:self.myPointBall :self.myScoreLabel];
    [myResultUtil updateLeftPredictionLabel:self.myFirstTeamPredictionLabel];
    [myResultUtil updateRightPredictionLabel:self.mySecondTeamPredictionLabel];
    
    [myResultUtil switchLeftPredictionBackground:self.myFirstPredictionBackground];
    [myResultUtil switchRightPredictionBackground:self.mySecondPredictionBackground];
    
    if (matchComparison.isNextMatch) {
        self.nextMatchBar.hidden = NO;
    }
    else {
        self.nextMatchBar.hidden = YES;
    }
}

@end
