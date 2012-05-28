//
//  Match.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Match.h"
#import "NSDate+DateConversion.h"
#import "BackendAdapter.h"

@implementation Match

@synthesize firstTeam = _firstTeam;
@synthesize secondTeam = _secondTeam;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize kickOff = _kickOff;
@synthesize points = _points;
@synthesize matchId = _matchId;
@synthesize played = _played;
@synthesize unknownOpponents = _unknownOpponents;
@synthesize matchRound = _matchRound;

+ (Match*) gameFromJson:(NSDictionary*) gameData {
    Match *match = [[Match alloc] init];
    
    match.matchId = [gameData objectForKey:@"matchId"];
    
    NSDictionary *teamNames = [BackendAdapter teamNames];
    
    NSString *firstTeamName = [gameData objectForKey:@"firstTeam"];
    match.firstTeam = [teamNames objectForKey:firstTeamName];
    NSString *secondTeamName = [gameData objectForKey:@"secondTeam"];
    match.secondTeam = [teamNames objectForKey:secondTeamName];
    
    // if a 'TBD' is found, we do not have any opponents yet!
    

    if ([match.firstTeam.shortName rangeOfString:@"tbd"].location != NSNotFound) {
        match.unknownOpponents = YES;
    }
    
    match.kickOff = [NSDate fromJsonTimestamp:[gameData valueForKey:@"kickOff"]];
    
    // extract results
    NSDictionary *result = [gameData objectForKey:@"result"];
    if (result) {
        
        id homeGoals = [result objectForKey:@"homeTeamGoals"];
        id awayGoals = [result objectForKey:@"awayTeamGoals"];
        
        if (homeGoals && homeGoals != [NSNull null]) {
            match.firstTeamGoals = homeGoals;
        }
        if (awayGoals && awayGoals != [NSNull null]) {
            match.secondTeamGoals = awayGoals;        
        }
    }
    
    // extract predictions
    NSDictionary *prediction = [gameData objectForKey:@"prediction"];
    if (prediction) {
        
        id homeGoals = [prediction objectForKey:@"homeTeamGoals"];
        id awayGoals = [prediction objectForKey:@"awayTeamGoals"];
        
        if (homeGoals && homeGoals != [NSNull null]) {
            match.firstTeamPrediction = homeGoals;
        }
        if (awayGoals && awayGoals != [NSNull null]) {
            match.secondTeamPrediction = awayGoals;        
        }
    }
    
    match.points = [gameData valueForKey:@"score"];
    
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
    return [NSString stringWithFormat:@"Match %@ - %@", self.firstTeam.shortName, self.secondTeam.shortName];
}

- (BOOL) finished {
    return self.firstTeamGoals && self.secondTeamGoals;
}

- (BOOL) hasPrediction {
    return self.firstTeamPrediction && self.secondTeamPrediction;
}

@end
