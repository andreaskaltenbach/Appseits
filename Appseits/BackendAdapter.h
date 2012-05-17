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
#import "ScorerRound.h"
#import "Top4Round.h"

typedef void(^FinishedBlock)(bool success);
typedef void(^TeamsFetchedBlock)(NSArray* teams);

@interface BackendAdapter : NSObject

+ (BOOL) credentialsAvailable;
+ (void) storeCredentials:(NSString*) email: (NSString*) password;
+ (void) validateCredentials:(FinishedBlock) onFinished;

+ (void) initializeModel:(FinishedBlock) onFinished;
+ (void) refreshModel:(FinishedBlock) onFinished;

+ (void) logout;

+ (League*) currentLeague;
+ (void) setCurrentLeague:(League*) league:(FinishedBlock) onDone;

+ (NSArray*) matchRounds;
+ (NSArray*) tournamentRounds;
+ (NSArray*) combinedTop4AndScorerRoundAndMatchRounds;
+ (Top4Round*) top4Round;
+ (ScorerRound*) scorerRound;
+ (NSArray*) rankings;
+ (NSArray*) leagues;
+ (NSArray*) teamList;
+ (NSDictionary*) teams;
+ (NSDictionary*) teamNames;
+ (NSArray*) playerList;
+ (NSDictionary*) players;

+ (UIImage*) imageForTeam:(NSString*) teamName;

+ (Top4Tips*) top4;

+ (void) postPrediction:(NSNumber*) matchId: (NSNumber*) firstTeamGoals: (NSNumber*) secondTeamGoals: (FinishedBlock) onDone;

+ (void) postPredictionForPlace:(int) place andTeam: (NSNumber*) teamId: (FinishedBlock) onDone;

+ (void) postPredictionForPlace:(int) place andPlayer: (NSNumber*) playerId: (FinishedBlock) onDone;

+ (NSString*) email;




@end
