//
//  RankingCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingCell.h"
#import "SSGradientView.h"

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;

@interface RankingCell()
@property (nonatomic, strong) UILabel *rank;
@property (nonatomic, strong) UIImageView *trend;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *points;
@property (nonatomic, strong) SSGradientView *background;

@end

@implementation RankingCell

@synthesize rank = _rank;
@synthesize trend = _trend;
@synthesize userName = _userName;
@synthesize points = _points;
@synthesize ranking = _ranking;
@synthesize background = _background;

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rank = (UILabel*) [self viewWithTag:1];
        self.trend = (UIImageView*) [self viewWithTag:2];
        
        self.userName = (UILabel*) [self viewWithTag:4];        
        
        self.points = (UILabel*) [self viewWithTag:5];        
        
        self.background = (SSGradientView*) [self viewWithTag:100];
    }
    return self;
}

- (void) setBackgroundGradientColor:(NSArray*) colors {
    self.background.colors = colors;
}

- (void) setRanking:(Ranking *)ranking {
    _ranking = ranking;
    self.rank.text = [NSString stringWithFormat:@"%i", ranking.rank.intValue];
    self.userName.text = ranking.userName;
    self.points.text = [NSString stringWithFormat:@"%.1f", ranking.totalPoints.floatValue];
    
    switch (ranking.trend) {
        case UP:
            self.trend.image = trendUp;
            break;
        case DOWN:
            self.trend.image = trendDown;
            break;
        default:
            self.trend.image = trendConstant;
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
