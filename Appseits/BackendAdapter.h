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

#define SERVER_URL @"http://vm2014.brunoson.se"

typedef enum {
    OK,
    NO_INTERNET,
    INTERNAL_SERVER_ERROR,
    INTERNAL_CLIENT_ERROR
} RemoteCallResult;

typedef void(^FinishedBlock)(bool success);
typedef void(^RemoteCallBlock)(RemoteCallResult error);
typedef void(^TeamsFetchedBlock)(NSArray* teams);

@interface BackendAdapter : NSObject

+ (BOOL) credentialsAvailable;
+ (void) storeCredentials:(NSString*) email: (NSString*) password;
+ (void) validateCredentials:(FinishedBlock) onFinished;

+ (void) initializeModel:(RemoteCallBlock) remoteCallBlock;
+ (BOOL) modelInitialized;
+ (void) refreshModel:(RemoteCallBlock) remoteCallBlock;

+ (void) logout;

+ (League*) currentLeague;
+ (void) setCurrentLeague:(League*) league:(RemoteCallBlock) remoteCallBlock;

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

+ (void) postPrediction:(NSNumber*) matchId: (NSNumber*) firstTeamGoals: (NSNumber*) secondTeamGoals: (RemoteCallBlock) remoteCallBlock;

+ (void) postPredictionForPlace:(int) place andTeam: (NSNumber*) teamId: (RemoteCallBlock) remoteCallBlock;

+ (void) postPredictionForPlace:(int) place andPlayer: (NSNumber*) playerId: (RemoteCallBlock) remoteCallBlock;

+ (NSString*) email;




@end
