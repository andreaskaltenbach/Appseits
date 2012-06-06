//
//  MatchResultUtil.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchResultUtil.h"
#import "UIColor+AppColors.h"

static UIColor* pointsBackground;
static UIImage *greenBall;
static UIImage *grayBall;
static UIImage *greenBallCheck;

@interface MatchResultUtil()

@property (nonatomic, strong) NSNumber* leftPrediction;
@property (nonatomic, strong) NSNumber* rightPrediction;
@property (nonatomic, strong) NSNumber* leftGoals;
@property (nonatomic, strong) NSNumber* rightGoals;
@property (nonatomic, strong) NSNumber* points;

@property BOOL leftPoints;
@property BOOL rightPoints;

@end

@implementation MatchResultUtil

@synthesize leftPoints = _leftPoints;
@synthesize leftPrediction = _leftPrediction;
@synthesize rightPoints = _rightPoints;
@synthesize rightPrediction = _rightPrediction;
@synthesize leftGoals = _leftGoals;
@synthesize rightGoals = _rightGoals;
@synthesize points = _points;

+ (void) initialize {
    pointsBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pointsBackgroundGreen"]];
    greenBall = [UIImage imageNamed:@"greenBall"];
    grayBall = [UIImage imageNamed:@"grayBall"];
    greenBallCheck = [UIImage imageNamed:@"greenBallCheck"];
    
}

+ (MatchResultUtil*) utilForPredictions:(NSNumber*) leftPrediction:(NSNumber*) rightPrediction forMatchResult: (NSNumber*) leftGoals:(NSNumber*) rightGoals withPoints:(NSNumber*) points {

    MatchResultUtil* util = [[MatchResultUtil alloc] init];
    
    util.leftPrediction = leftPrediction;
    util.rightPrediction = rightPrediction;
    
    util.leftGoals = leftGoals;
    util.rightGoals = rightGoals;
    
    util.points = points;
    
    // highlight predictions
    if (!leftGoals && !rightGoals) {
        util.leftPoints = NO;
        util.rightPoints = NO;
    }
    else if (leftPrediction.intValue == leftGoals.intValue
             && rightPrediction.intValue == rightGoals.intValue) {
        // correct result predicted -> show both green boxes:
        util.leftPoints = YES;
        util.rightPoints = YES;
    }
    else {
        int resultDiff = leftGoals.intValue - rightGoals.intValue;
        int predictionDiff = leftPrediction.intValue - rightPrediction.intValue;
        
        if (resultDiff == 0 && predictionDiff == 0) {
            // X was predicted correctly
            util.leftPoints = YES;
            util.rightPoints = YES;
            
        } else if (resultDiff * predictionDiff > 0) {
            // 1 or 2 was predicted correctly
            
            if (resultDiff > 0) {
                util.leftPoints = YES;
                util.rightPoints = NO;
            }
            else {
                util.leftPoints = NO;
                util.rightPoints = YES;
            }
        } else {
            util.leftPoints = NO;
            util.rightPoints = NO;
        }
    }
    return util;
}

- (void) switchLeftPredictionBackground:(UIView*) backgroundImage {
    if (self.leftPoints) {
        backgroundImage.backgroundColor = pointsBackground;
    }
    else {
        backgroundImage.backgroundColor = [UIColor clearColor];
    }
}

- (void) switchRightPredictionBackground:(UIView*) backgroundImage {
    if (self.rightPoints) {
        backgroundImage.backgroundColor = pointsBackground;
    }
    else {
        backgroundImage.backgroundColor = [UIColor clearColor];
    }
}

- (void) updateLeftPredictionLabel:(UILabel*) predictionLabel {
    if (self.leftPoints) {
        predictionLabel.textColor = [UIColor whiteColor];
    }
    else {
        predictionLabel.textColor = [UIColor transparentWhite];
    }
}
- (void) updateRightPredictionLabel:(UILabel*) predictionLabel {
    if (self.rightPoints) {
        predictionLabel.textColor = [UIColor whiteColor];
    }
    else {
        predictionLabel.textColor = [UIColor transparentWhite];
    }
}

- (void) updatePointsBall:(UIImageView*) pointBallBackground: (UILabel*) pointsLabel {
    // change ball
    if (!self.leftGoals && !self.rightGoals) {
        if (!self.leftPrediction && !self.rightPrediction) {
            // game is not yet played and no predictions are made
            pointBallBackground.hidden = YES;
            pointsLabel.hidden = YES;
        }
        else {
            // match is not yet played and but predictions are made
            pointBallBackground.hidden = NO;
            pointBallBackground.image = greenBallCheck;
            pointsLabel.hidden = YES;
        }
    }
    else {
        if (self.points.intValue > 0) {
            // match is played and user got points
            pointBallBackground.hidden = NO;
            pointBallBackground.image = greenBall;
            pointsLabel.hidden = NO;
            pointsLabel.text = [NSString stringWithFormat:@"%ip", self.points.intValue];
            pointsLabel.opaque = 1;
        }
        else {
            // match is played and user got 0 points
            pointBallBackground.hidden = NO;
            pointBallBackground.image = grayBall;
            pointsLabel.hidden = NO;
            pointsLabel.text = @"0p";
            pointsLabel.opaque = 0.4;
        }
    }
    
}

@end
