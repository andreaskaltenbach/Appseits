//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "BackendAdapter.h"
#import "Match.h"

@implementation TournamentRound

@synthesize roundName = _roundName;
@synthesize lockDate = _lockDate;
@synthesize startDate = _startDate;

- (BOOL) locked {
    if (!self.lockDate) return NO;
    return [self.lockDate compare:[NSDate date]] == NSOrderedAscending;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"Tournament round %@", self.roundName];
}

- (float) points {
    return 0;
}

- (float) progress {
    return 0;
}

- (BOOL) open {
    NSDate *now = [NSDate date];
    // locked date has not passed
    return ([now compare:self.lockDate] == NSOrderedAscending);
}

- (BOOL) allPredictionsDone {
    return NO;
}

+ (float) totalPoints {
    float totalPoints = 0;
    for (TournamentRound* round in [BackendAdapter tournamentRounds]) {
        totalPoints+= round.points;
    }
    return totalPoints;
}

+ (TournamentRound*) lastClosedRound:(NSArray*) tournamentRounds {
    // take the first round as fallback
    TournamentRound* lastClosedRound = [tournamentRounds objectAtIndex:0];
    
    for (TournamentRound* round in tournamentRounds) {
        if (!round.open) {
            lastClosedRound = round;
        }
    }
    
    return lastClosedRound;
}

+ (TournamentRound*) activeRound:(NSArray*) tournamentRounds {
    
    // find all open rounds
    NSMutableArray* openRounds = [NSMutableArray array];
    for (TournamentRound* round in tournamentRounds) {
        if (round.open) {
            [openRounds addObject:round];
        }
    }
    
    if ([openRounds count] == [tournamentRounds count]) {
        // all rounds are still open -> return first incomplete round as active
        for (TournamentRound* round in openRounds) {
            if (!round.allPredictionsDone) {
                return round;
            }
        }
    }
    else {
        
        TournamentRound *roundWithLastMatch;
        NSDate* now = [NSDate date];
        
        // at least one round is closed -> get round with closest match
        for (TournamentRound* round in tournamentRounds) {
            if ([round isKindOfClass:MatchRound.class]) {
                
                // take the first round as active round (as fallback)
                if (!roundWithLastMatch) {
                    roundWithLastMatch = round;
                }
                
                MatchRound* matchRound = (MatchRound*) round;
                
                for (Match* match in matchRound.matches) {
                    // check each match whether it was already played -> if yes, this round or a later one should be active
                    if (match.kickOff && [match.kickOff compare:now] == NSOrderedAscending) {
                        roundWithLastMatch = round;
                    }
                }
            }
        }
        
        if (roundWithLastMatch) {
            return roundWithLastMatch;
        }
    }
    
    // if no round could be identified, we simply return the first round
    return [tournamentRounds objectAtIndex:0];

    // if no active round can be identified, we take the first one
    if ([openRounds count] == 0) return [tournamentRounds objectAtIndex:0];
    
    // return the first round that is not completely predicted
    for (TournamentRound* round in openRounds) {
        if (!round.allPredictionsDone) {
            return round;
        }
    }
        
    // if all predictions are done, return the first round
    return [openRounds objectAtIndex:0];
}

@end
