//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "Game.h"

@implementation TournamentRound

@synthesize roundName = _roundName;
@synthesize games = _matches;
@synthesize locked = _locked;


- (int) points {
    int points = 0;
    for(Game *game in self.games) {
        points += game.points.intValue;
    }
    return points;
}

+ (TournamentRound*) tournamentRoundFromJson:(NSDictionary*) jsonData {
    TournamentRound *round = [[TournamentRound alloc] init];
    round.roundName = [jsonData objectForKey:@"name"];
    round.games = [Game gamesFromJson: [jsonData objectForKey:@"games"]];
    return round;
}

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds {
    NSMutableArray *rounds = [NSMutableArray array];
    
    for (NSDictionary *roundData in jsonRounds) {
        [rounds addObject:[TournamentRound tournamentRoundFromJson:roundData]];
    }
    
    return rounds;
}



@end
