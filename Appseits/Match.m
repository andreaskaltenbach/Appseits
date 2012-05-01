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

+ (Match*) gameFromJson:(NSDictionary*) gameData {
    Match *game = [[Match alloc] init];
    game.firstTeamName = [gameData objectForKey:@"firstTeam"];
    game.secondTeamName = [gameData objectForKey:@"secondTeam"];
    game.kickOff = [NSDate fromJsonTimestamp:[gameData valueForKey:@"kickOff"]];
    
    NSNumber *firstTeamGoals = [gameData valueForKey:@"firstTeamGoals"];
    if (firstTeamGoals) game.firstTeamGoals = firstTeamGoals;
    
    NSNumber *secondTeamGoals = [gameData valueForKey:@"secondTeamGoals"];
    if (secondTeamGoals) game.secondTeamGoals = secondTeamGoals;
    
    game.firstTeamPrediction = [gameData valueForKey:@"firstTeamGoalsBet"];
    game.secondTeamPrediction = [gameData valueForKey:@"secondTeamGoalsBet"];
    game.points = [gameData valueForKey:@"points"];
    return game;
}

+ (NSArray*) gamesFromJson: (NSArray*) jsonData {
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
