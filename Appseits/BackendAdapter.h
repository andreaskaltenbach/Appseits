//
//  BackendAdapter.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"
#import "TournamentRound.h"

typedef void(^FinishedBlock)(bool success);

@protocol MatchUpdateDelegate
- (void) matchesUpdated:(TournamentRound*) round;
@end

@protocol RankingUpdateDelegate
- (void) rankingsUpdated:(NSArray*) rankings;
@end

@interface BackendAdapter : NSObject

+ (BOOL) credentialsAvailable;
+ (void) storeCredentials:(NSString*) email: (NSString*) password;
+ (void) validateCredentials:(FinishedBlock) onFinished;

+ (void) initializeModel:(FinishedBlock) onFinished;

+ (void) logout;

+ (League*) currentLeague;
+ (void) setCurrentLeague:(League*) league:(FinishedBlock) onDone;

+ (NSArray*) tournamentRounds;
+ (NSArray*) rankings;
+ (NSArray*) leagues;

+ (void) addMatchUpdateDelegate:(id<MatchUpdateDelegate>) delegate;
+ (void) addRankingUpdateDelegate:(id<RankingUpdateDelegate>) delegate;

+ (void) updateMatches;
+ (void) updateRankings;


@end
