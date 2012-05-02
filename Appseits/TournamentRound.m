//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "Match.h"
#import "NSDate+DateConversion.h"

@implementation TournamentRound

@synthesize roundName = _roundName;
@synthesize matches = _matches;
@synthesize lockDate = _lockDate;

- (BOOL) isActive {
    if (!self.locked) return NO;
    
    for (Match* match in self.matches) {
        if (!match.finished) return YES;
    }
    return NO;
}

- (int) points {
    int points = 0;
    for(Match *game in self.matches) {
        points += game.points.intValue;
    }
    return points;
}

+ (TournamentRound*) tournamentRoundFromJson:(NSDictionary*) jsonData {
    TournamentRound *round = [[TournamentRound alloc] init];
    round.roundName = [jsonData objectForKey:@"name"];
    round.matches = [Match gamesFromJson: [jsonData objectForKey:@"matches"]];
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
    return [self.lockDate compare:[NSDate date]] == NSOrderedAscending;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Tournament round %@", self.roundName];
}

@end
