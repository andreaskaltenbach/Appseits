//
//  MatchCellCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchPredictionCell.h"
#import "Match.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"
#import "BackendAdapter.h"

@interface MatchPredictionCell()

@property (nonatomic, strong) UILabel *matchResultLabel;
@property (nonatomic, strong) UILabel *pointsLabel;
@property (nonatomic, strong) NSNumber *firstTeamPrediction;
@property (nonatomic, strong) NSNumber *secondTeamPrediction;

@end

@implementation MatchPredictionCell

@synthesize matchResultLabel = _matchResultLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamPrediction = _secondTeamPrediction;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

- (void) setMatch:(Match *)match {
    [super setMatch:match];
}

@end
