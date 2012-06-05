//
//  ComparisonCell.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComparisonCell.h"

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
@property (nonatomic, strong) UILabel* competitorScoreLabel;

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
        
        self.myInitials = (UILabel*) [self viewWithTag:31];
        self.competitorInitials = (UILabel*) [self viewWithTag:32];
        
        self.myFirstTeamPredictionLabel = (UILabel*) [self viewWithTag:33];
        self.mySecondTeamPredictionLabel = (UILabel*) [self viewWithTag:34];
        
        self.competitorFirstTeamPredictionLabel = (UILabel*) [self viewWithTag:35];
        self.competitorSecondTeamPredictionLabel = (UILabel*) [self viewWithTag:36];

        self.myScoreLabel = (UILabel*) [self viewWithTag:37];
        self.competitorScoreLabel = (UILabel*) [self viewWithTag:38];
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
}

@end
