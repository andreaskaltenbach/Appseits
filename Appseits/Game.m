//
//  Match.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize kickOff = _kickOff;

- (BOOL) isLocked {
     NSDate *now = [NSDate date];
    return [now compare:self.kickOff] == NSOrderedAscending;
}

@end
