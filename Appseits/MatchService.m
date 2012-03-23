//
//  MatchService.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchService.h"
#import "Match.h"
#import "TournamentRound.h"

@implementation MatchService

+ (void) getMatches:(SuccessBlock) onSuccess: (FailedBlock) onError {
    
    // fetch data in background and execute callback when data is available:
    
    Match *match1 = [[Match alloc] init];
    match1.firstTeamName = @"Pol";
    match1.secondTeamName = @"Gre";
    
    Match *match2 = [[Match alloc] init];
    match2.firstTeamName = @"Rus";
    match2.secondTeamName = @"Cze";
    
    TournamentRound *firstRound = [[TournamentRound alloc] init];
    firstRound.matches = [NSArray arrayWithObjects:match1, match2, nil];
    firstRound.roundName = @"Omgång 1";
    
    TournamentRound *secondRound = [[TournamentRound alloc] init];
    secondRound.matches = [NSArray arrayWithObjects:match1, match2, nil];
    secondRound.roundName = @"Omgång 2";
    
    NSArray *matches = [NSArray arrayWithObjects:firstRound, secondRound, nil];
    
    onSuccess(matches);
}

@end
