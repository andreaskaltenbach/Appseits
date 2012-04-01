//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "Game.h"
#import "NSDate+DateConversion.h"

@implementation TournamentRound

@synthesize roundName = _roundName;
@synthesize games = _matches;
@synthesize lockDate = _lockDate;

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
    round.lockDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"lockedDate"]];
    return round;
}

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds {
    NSMutableArray *rounds = [NSMutableArray array];
    
    for (NSDictionary *roundData in jsonRounds) {
        [rounds addObject:[TournamentRound tournamentRoundFromJson:roundData]];
    }
    
    return rounds;
}

- (BOOL) locked {
    if (!self.lockDate) return NO;
    NSLog(@"Locked date %@", self.lockDate);
    
    return [self.lockDate compare:[NSDate date]] == NSOrderedAscending;
}



@end
