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
    match1.firstTeamGoals = 0;
    match1.secondTeamGoals = 3;
    match1.kickOff = past;
    match1.points = 3;
    
    Game *match2 = [[Game alloc] init];
    match2.firstTeamName = @"Rus";
    match2.secondTeamName = @"Cze";
    match2.firstTeamGoals = 4;
    match2.secondTeamGoals = 1;
    match2.kickOff = past;
    match2.points = 2;
    
    Game *match3 = [[Game alloc] init];
    match3.firstTeamName = @"Ned";
    match3.secondTeamName = @"Den";
    match3.kickOff = future;
    
    Game *match4 = [[Game alloc] init];
    match4.firstTeamName = @"Ger";
    match4.secondTeamName = @"Por";
    match4.kickOff = future;
    
    TournamentRound *firstRound = [[TournamentRound alloc] init];
    firstRound.games = [NSArray arrayWithObjects:match1, match2, nil];
    firstRound.roundName = @"Omgång 1";
    firstRound.locked = YES;
    
    TournamentRound *secondRound = [[TournamentRound alloc] init];
    secondRound.games = [NSArray arrayWithObjects:match3, match4, nil];
    secondRound.roundName = @"Omgång 2";
    secondRound.locked = NO;
    
    NSArray *matches = [NSArray arrayWithObjects:firstRound, secondRound, nil];
    
    onSuccess(matches);
}

@end
