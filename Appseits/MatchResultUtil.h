//
//  MatchResultUtil.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchResultUtil : NSObject

+ (MatchResultUtil*) utilForPredictions:(NSNumber*) leftPrediction:(NSNumber*) rightPrediction forMatchResult: (NSNumber*) leftGoals:(NSNumber*) rightGoals withPoints:(NSNumber*) points;

- (void) switchLeftPredictionBackground:(UIView*) backgroundImage;
- (void) switchRightPredictionBackground:(UIView*) backgroundImage;

- (void) updateLeftPredictionLabel:(UILabel*) predictionLabel;
- (void) updateRightPredictionLabel:(UILabel*) predictionLabel;

- (void) updatePointsBall:(UIImageView*) pointBallBackground: (UILabel*) pointsLabel;

@end
