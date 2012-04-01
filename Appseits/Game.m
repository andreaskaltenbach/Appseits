//
//  Match.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "NSDate+DateConversion.h"

@implementation Game

@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;
@synthesize firstTeamGoals = _firstTeamGoals;
@synthesize secondTeamGoals = _secondTeamGoals;
@synthesize firstTeamPrediction = _firstTeamPrediction;
@synthesize secondTeamPrediction = _secondTeamPrediction;
@synthesize kickOff = _kickOff;
@synthesize points = _points;

+ (Game*) gameFromJson:(NSDictionary*) gameData {
    Game *game = [[Game alloc] init];
    game.firstTeamName = [gameData objectForKey:@"firstTeam"];
    game.secondTeamName = [gameData objectForKey:@"secondTeam"];
    game.kickOff = [NSDate fromJsonTimestamp:[gameData valueForKey:@"kickOff"]];
    game.firstTeamGoals = [gameData valueForKey:@"firstTeamGoals"];
    game.secondTeamGoals = [gameData valueForKey:@"secondTeamGoals"];
    game.firstTeamPrediction = [gameData valueForKey:@"firstTeamGoalsBet"];
    game.secondTeamPrediction = [gameData valueForKey:@"secondTeamGoalsBet"];
    game.points = [gameData valueForKey:@"points"];
    return game;
}

+ (NSArray*) gamesFromJson: (NSArray*) jsonData {
    NSMutableArray *games = [NSMutableArray array];
    for (NSDictionary *gameData in jsonData) {
        [games addObject:[Game gameFromJson:gameData]];
    }
    return games;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Game %@ - %@", self.firstTeamName, self.secondTeamName];
}

@end
