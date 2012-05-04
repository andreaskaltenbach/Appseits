//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchRound.h"
#import "Match.h"
#import "NSDate+DateConversion.h"

@implementation MatchRound

@synthesize matches = _matches;



- (int) points {
    int points = 0;
    for(Match *game in self.matches) {
        points += game.points.intValue;
    }
    return points;
}

+ (MatchRound*) tournamentRoundFromJson:(NSDictionary*) jsonData {
    MatchRound *round = [[MatchRound alloc] init];
    round.roundName = [jsonData objectForKey:@"name"];
    round.matches = [Match gamesFromJson: [jsonData objectForKey:@"matches"]];
    round.lockDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"lockedDate"]];
    return round;
}

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds {
    NSMutableArray *rounds = [NSMutableArray array];
    
    for (NSDictionary *roundData in jsonRounds) {
        [rounds addObject:[MatchRound tournamentRoundFromJson:roundData]];
    }
    
    return rounds;
}





@end
