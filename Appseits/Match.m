//
//  Match.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Match.h"
#import "NSDate+DateConversion.h"

@implementation Match

@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize kickOff = _kickOff;
@synthesize points = _points;
@synthesize matchId = _matchId;
@synthesize played = _played;
@synthesize unknownOpponents = _unknownOpponents;

+ (Match*) gameFromJson:(NSDictionary*) gameData {
    Match *match = [[Match alloc] init];
    
    match.matchId = [gameData objectForKey:@"matchId"];
    

    match.firstTeamName = [gameData objectForKey:@"firstTeam"];
    match.secondTeamName = [gameData objectForKey:@"secondTeam"];
    
    // if a 'TBD' is found, we do not have any opponents yet!
    if ([match.firstTeamName rangeOfString:@"tbd"].location != NSNotFound) {
        match.unknownOpponents = YES;
    }
    
    match.kickOff = [NSDate fromJsonTimestamp:[gameData valueForKey:@"kickOff"]];
    
    NSDictionary *result = [gameData objectForKey:@"result"];
    if (result) {
        
        id homeGoals = [result objectForKey:@"homeTeamScore"];
        id awayGoals = [result objectForKey:@"awayTeamScore"];
        
        
        
        NSLog(@"Class: %@", [homeGoals class]);
        if (homeGoals && homeGoals != [NSNull null]) {
            match.firstTeamGoals = homeGoals;
        }
        if (awayGoals && awayGoals != [NSNull null]) {
            match.secondTeamGoals = awayGoals;        
        }
    }
    
    
    NSNumber *firstTeamGoals = [gameData valueForKey:@"firstTeamGoals"];
    if (firstTeamGoals) match.firstTeamGoals = firstTeamGoals;
    
    NSNumber *secondTeamGoals = [gameData valueForKey:@"secondTeamGoals"];
    if (secondTeamGoals) match.secondTeamGoals = secondTeamGoals;
    
    
    match.firstTeamPrediction = [gameData valueForKey:@"firstTeamGoalsBet"];
    match.secondTeamPrediction = [gameData valueForKey:@"secondTeamGoalsBet"];
    match.points = [gameData valueForKey:@"matchPoints"];
    
    return match;
}

+ (NSArray*) matchFromJson: (NSArray*) jsonData {
    NSMutableArray *games = [NSMutableArray array];
    for (NSDictionary *gameData in jsonData) {
        [games addObject:[Match gameFromJson:gameData]];
    }
    return games;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Match %@ - %@", self.firstTeamName, self.secondTeamName];
}

- (BOOL) finished {
    return self.firstTeamGoals && self.secondTeamGoals;
}

@end
