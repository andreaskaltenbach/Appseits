//
//  BackendAdapter.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"
#import "MatchRound.h"
#import "Top4Tips.h"

typedef void(^FinishedBlock)(bool success);
typedef void(^TeamsFetchedBlock)(NSArray* teams);

@protocol MatchUpdateDelegate
- (void) matchesUpdated:(MatchRound*) round;
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
+ (NSArray*) teamList;
+ (NSDictionary*) teams;
+ (NSArray*) playerList;
+ (NSDictionary*) players;

+ (UIImage*) imageForTeam:(NSString*) teamName;

+ (Top4Tips*) top4;

+ (void) addMatchUpdateDelegate:(id<MatchUpdateDelegate>) delegate;
+ (void) addRankingUpdateDelegate:(id<RankingUpdateDelegate>) delegate;

+ (void) updateMatches;
+ (void) updateRankings;

+ (void) postPrediction:(NSNumber*) matchId: (NSNumber*) firstTeamGoals: (NSNumber*) secondTeamGoals: (FinishedBlock) onDone;

+ (void) postPredictionForPlace:(int) place andTeam: (NSNumber*) teamId: (FinishedBlock) onDone;




@end
