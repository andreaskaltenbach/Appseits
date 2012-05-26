//
//  Match.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "MatchRound.h"

@class MatchRound;

@interface Match : NSObject

@property (nonatomic, strong) Team *firstTeam;
@property (nonatomic, strong) Team *secondTeam;
@property (nonatomic, strong) NSDate *kickOff;
@property (nonatomic, strong) NSNumber *firstTeamGoals;
@property (nonatomic, strong) NSNumber *secondTeamGoals;
@property (nonatomic, strong) NSNumber *firstTeamPrediction;
@property (nonatomic, strong) NSNumber *secondTeamPrediction;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSNumber *matchId;
@property (nonatomic, strong) MatchRound *matchRound;
@property BOOL played;
@property BOOL unknownOpponents;


+ (NSArray*) matchFromJson: (NSArray*) jsonData;

- (BOOL) finished;

- (BOOL) hasPrediction;

@end
