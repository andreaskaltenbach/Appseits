//
//  TournamentRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TournamentRound : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *lockDate;
@property (nonatomic, strong) NSString *roundName;

- (float) points;

- (float) progress;

- (BOOL) notPassed;

- (BOOL) started;

- (BOOL) allPredictionsDone;

+ (TournamentRound*) activeRound:(NSArray*) tournamentRounds;
+ (TournamentRound*) lastClosedRound:(NSArray*) tournamentRounds;

+ (float) totalPoints;

- (BOOL) readyToBet;

@end
