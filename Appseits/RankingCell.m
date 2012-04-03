//
//  RankingCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingCell.h"

@interface RankingCell()
@property (nonatomic, strong) UILabel *rank;
@property (nonatomic, strong) UIImageView *trend;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *points;

@end

@implementation RankingCell

@synthesize rank = _rank;
@synthesize trend = _trend;
@synthesize userName = _userName;
@synthesize points = _points;
@synthesize ranking = _ranking;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rank = (UILabel*) [self viewWithTag:1];
        self.trend = (UIImageView*) [self viewWithTag:2];
        
        self.userName = (UILabel*) [self viewWithTag:4];        
        
        self.points = (UILabel*) [self viewWithTag:5];        
    }
    return self;
}

- (void) setRanking:(Ranking *)ranking {
    _ranking = ranking;
    
    self.userName.text = ranking.userName;
    self.points.text = [NSString stringWithFormat:@"%f", ranking.totalPoints.floatValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
