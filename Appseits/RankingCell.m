//
//  RankingCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingCell.h"
#import "SSGradientView.h"
#import "UIColor+AppColors.h"
#import "BackendAdapter.h"

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;
static UIImage *userGreen;
static UIImage *userGray;

@interface RankingCell()
@property (nonatomic, strong) UILabel *rank;
@property (nonatomic, strong) UIImageView *trend;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *points;
@property (nonatomic, strong) SSGradientView *background;
@property (nonatomic, strong) UIImageView *userImage;
@property BOOL myself;

@end

@implementation RankingCell

@synthesize rank = _rank;
@synthesize trend = _trend;
@synthesize userName = _userName;
@synthesize points = _points;
@synthesize ranking = _ranking;
@synthesize background = _background;
@synthesize even = _even;
@synthesize myself = _myself;
@synthesize userImage = _userImage;

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
    userGray = [UIImage imageNamed:@"userGray"];
    userGreen = [UIImage imageNamed:@"userGreen"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rank = (UILabel*) [self viewWithTag:1];
        //self.trend = (UIImageView*) [self viewWithTag:2];
        
        self.userImage = (UIImageView*) [self viewWithTag:999];
        self.userName = (UILabel*) [self viewWithTag:4];        
        
        self.points = (UILabel*) [self viewWithTag:5];        
        
        self.background = (SSGradientView*) [self viewWithTag:100];
        
        self.background.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setRanking:(Ranking *)ranking {
    _ranking = ranking;
    self.rank.text = [NSString stringWithFormat:@"%i", ranking.rank.intValue];
    self.userName.text = ranking.competitorName;
    self.points.text = [NSString stringWithFormat:@"%.1f", ranking.totalPoints.floatValue];
    
    if ([self.ranking.competitorId isEqualToString:[BackendAdapter userId]]) {
        self.myself = YES;
    }
    else {
        self.myself = NO;
    }
    
    
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
 
    if (selected) {
        self.userName.textColor = [UIColor whiteColor];
        self.points.textColor = [UIColor whiteColor];
        self.rank.textColor = [UIColor whiteColor];
        self.background.colors = [UIColor selectedSection];
    }
    else {
        self.userName.textColor = [UIColor blackColor];
        self.points.textColor = [UIColor blackColor];
        self.rank.textColor = [UIColor blackColor];
        self.background.colors = nil;
        
        if (self.myself) {
            self.background.backgroundColor = [UIColor rankingSelected];
        }
        
        else {
            if (self.even) {
                self.background.backgroundColor = [UIColor rankingEven];
            }
            else {
                self.background.backgroundColor = [UIColor rankingOdd];
                
            }
        }
    }
    
    
    // handle user icon
    CGRect userNameFrame = self.userName.frame;
    if (self.myself) {
        
        if (selected) {
            self.userImage.hidden = YES;
        }
        else {
            self.userImage.hidden = NO;
            self.userImage.image = userGreen;
        }
        
        userNameFrame.origin.x = 72;
        userNameFrame.size.width = 210;
    }
    else {
        self.userImage.hidden = YES;
        userNameFrame.origin.x = 52;
        userNameFrame.size.width = 190;
    }
    self.userName.frame = userNameFrame;
}

- (void) setHighlighted:(BOOL)highlighted {
    
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
