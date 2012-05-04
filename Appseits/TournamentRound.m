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


- (RoundState) roundState {
    NSDate *now = [NSDate date];
    if ([now compare:self.lockDate] == NSOrderedDescending) {
        // lock date has passed
        return CLOSED;
    }
    if ([now compare: self.startDate] == NSOrderedDescending) {
        // start date has passed and lock date has not passed 
        return OPEN;
    }
    
    // start date has not yet reached
    return FUTURE;
}

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

@end
