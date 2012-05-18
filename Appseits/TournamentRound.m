//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"

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

- (int) points {
    return 0;
}

- (float) progress {
    return 0;
}

- (BOOL) open {
    NSDate *now = [NSDate date];
    NSLog(@"Now: %@", now);
        NSLog(@"LockDate: %@", self.lockDate);
    // locked date has not passed
    BOOL open = ([now compare:self.lockDate] == NSOrderedAscending);
    NSLog(@"Open:%i", open);
    return open;
}

- (BOOL) allPredictionsDone {
    return NO;
}

+ (TournamentRound*) activeRound:(NSArray*) tournamentRounds {
    
    for (TournamentRound* round in tournamentRounds) {
        if (round.open) {
            return round;
        }
    }
    
    // if no active round can be identified, we take the first one
    return [tournamentRounds objectAtIndex:0];
}

@end
