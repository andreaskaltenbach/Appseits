//
//  MatchService.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameService.h"
#import "Game.h"
#import "TournamentRound.h"

@implementation GameService

+ (void) getGames:(SuccessBlock) onSuccess: (FailedBlock) onError {
    
    // fetch data in background and execute callback when data is available:
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *past = [dateFormatter dateFromString:@"2012-03-01"];
    NSDate *future = [dateFormatter dateFromString:@"2013-12-01"];
    
    Game *match1 = [[Game alloc] init];
    match1.firstTeamName = @"Pol";
    match1.secondTeamName = @"Gre";
    match1.kickOff = past;
    
    Game *match2 = [[Game alloc] init];
    match2.firstTeamName = @"Rus";
    match2.secondTeamName = @"Cze";
    match1.kickOff = future;
    
    TournamentRound *firstRound = [[TournamentRound alloc] init];
    firstRound.games = [NSArray arrayWithObjects:match1, match2, nil];
    firstRound.roundName = @"Omgång 1";
    
    TournamentRound *secondRound = [[TournamentRound alloc] init];
    secondRound.games = [NSArray arrayWithObjects:match1, match2, nil];
    secondRound.roundName = @"Omgång 2";
    
    NSArray *matches = [NSArray arrayWithObjects:firstRound, secondRound, nil];
    
    onSuccess(matches);
}

@end
