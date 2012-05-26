//
//  BackendAdapter.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackendAdapter.h"
#import "MatchRound.h"
#import "Ranking.h"
#import "League.h"
#import "Constants.h"
#import "Match.h"
#import "Top4Tips.h"
#import "Top4Round.h"
#import "Team.h"
#import "ScorerRound.h"
#import "CompositeTop4AndScorerRound.h"

static NSString *leagueUrl;
static NSString *rankingUrl;

static NSArray *rounds;
static NSArray *rankings;
static NSArray *leagues;

static League *currentLeague;

static NSString *token;
static NSString *userName;
static NSString *userId;
static NSString *userEmail;

static NSArray *teams;
static NSMutableDictionary *teamDictionary;
static NSMutableDictionary *teamNames;
static NSMutableArray *players;
static NSMutableDictionary *playerDictionary;

static Top4Round *top4Round;
static ScorerRound *scorerRound;

static BOOL modelInitialized;

#define FLAG_URL @"http://img.uefa.com/imgml/flags/32x32/%@.png"

static NSString* LOGIN_URL;
static NSString* ROUNDS_URL;
static NSString* BET_URL;
static NSString* TOP4_URL;
static NSString* SCORER_URL;
static NSString* TEAMS_URL;

@implementation BackendAdapter

+ (void) initialize {
    leagueUrl = @"http://dl.dropbox.com/u/15650647/leagues.json";
    rankingUrl = @"http://dl.dropbox.com/u/15650647/ranking.json";
    
    LOGIN_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/login"];
    ROUNDS_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/rounds"];
    BET_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/bet"];
    TOP4_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/winners"];
    SCORER_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/topscorer"];
    TEAMS_URL = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"/api/teams"];
}

+ (BOOL) modelInitialized {
    return modelInitialized;
}

+ (BOOL) credentialsAvailable {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"email"] != nil && [userDefaults objectForKey:@"password"] != nil;
}

+ (void) storeCredentials:(NSString*) email: (NSString*) password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:email forKey:@"email"];
    [userDefaults setValue:password forKey:@"password"];
    [userDefaults synchronize];
}

+ (void) validateCredentials:(FinishedBlock) onFinished {
    
    dispatch_queue_t credentialQueue = dispatch_queue_create("credentialsCheck", NULL);
    
    dispatch_async(credentialQueue, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *email = [userDefaults objectForKey:@"email"];
        NSString *password = [userDefaults objectForKey:@"password"];
        
        if (email && password) {
            
            // validate credentials and retrieve a token in response
            NSURL *url = [NSURL URLWithString:LOGIN_URL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod = @"POST";
            
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      email,@"Username",
                                      password,@"Password",nil];
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:kNilOptions error:&error];
            request.HTTPBody = data;
            NSHTTPURLResponse *response;
            
            NSData *userData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (response.statusCode != 200) {   
                // an error occured
                if(response.statusCode == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        onFinished(NO);
                    });
                    return;
                }
                
                if (response.statusCode != 401) {
                    NSLog(@"Status code: %i", response.statusCode);
                    // some unexpected has happened:
                    dispatch_async(dispatch_get_main_queue(), ^{
                        onFinished(NO);
                    });
                    return;
                    
                    
                }
                // return a negative response
                dispatch_async(dispatch_get_main_queue(), ^{
                    onFinished(NO);
                });
                return;
            }
            
            // credentials are valid -> we grab the user information and token and store it
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:userData
                                  options:kNilOptions 
                                  error:&error];
            token = [json objectForKey:@"auth"];
            userName = [json objectForKey:@"name"];
            userId = [json objectForKey:@"userId"];            
            userEmail = email;
            
            NSLog(@"Token: %@", token);
            NSLog(@"User Name: %@", userName);
            NSLog(@"User ID: %@", userId);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                onFinished(YES);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                onFinished(NO);
            });
        }  
    });
}                  

+ (void) logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"email"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
}

+ (void) refreshModel:(RemoteCallBlock) remoteCallBlock {
    
    if (!modelInitialized) {
        // if model is not fully initialized, we have to initialize it instead of refreshing it.
        [BackendAdapter initializeModel:remoteCallBlock];
    }
    else {

        dispatch_queue_t refreshQueue = dispatch_queue_create("refresh", NULL);
        
        dispatch_async(refreshQueue, ^{
            
            RemoteCallResult remoteCallResult = [self loadCompleteTournament];
            
            // TODO -enable league and ranking fetching!
            /*if (remoteCallResult == OK) {
             remoteCallResult = [self loadLeagues];
             }
             if (remoteCallResult == OK) {
             remoteCallResult = [self loadRankings];
             }*/
            
            if (remoteCallResult == OK) {
                remoteCallResult = [self loadTop4];
            }
            if (remoteCallResult == OK) {
                remoteCallResult = [self loadScorer];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                remoteCallBlock(remoteCallResult);
            });
        });

    }
}

+ (void) initializeModel:(RemoteCallBlock) remoteCallBlock {
    
    dispatch_queue_t initQueue = dispatch_queue_create("initialization", NULL);

    dispatch_async(initQueue, ^{
        
        RemoteCallResult remoteCallResult = [self fetchTeams];
        if (remoteCallResult == OK) {
            remoteCallResult = [self loadCompleteTournament];
        }
        // TODO -enable league and ranking fetching!
        /*if (remoteCallResult == OK) {
            remoteCallResult = [self loadLeagues];
        }
        if (remoteCallResult == OK) {
            remoteCallResult = [self loadRankings];
        }*/
        if (remoteCallResult == OK) {
            remoteCallResult = [self loadFlags];
        }
        if (remoteCallResult == OK) {
            remoteCallResult = [self loadTop4];
        }
        if (remoteCallResult == OK) {
            remoteCallResult = [self loadScorer];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            modelInitialized = YES;
            remoteCallBlock(remoteCallResult);
        });
    });
}

+ (RemoteCallResult) loadFlags {
    
    // prepare the file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *teamName in teamNames.allKeys) {
        
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", teamName]];
        
        if (![fileManager fileExistsAtPath:filePath]) {
            
            // download flag from UEFA:
            NSURL *flagUrl = [NSURL URLWithString:[NSString stringWithFormat:FLAG_URL, teamName]];
            NSURLRequest* flagRequest = [NSURLRequest requestWithURL:flagUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
            NSURLResponse *response;
            NSError *error;

            NSData *flagData = [NSURLConnection sendSynchronousRequest:flagRequest returningResponse:&response error:&error];
            
            RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
            if (remoteCallResult != OK) return remoteCallResult;
                
            // write flag file to disk
            [flagData writeToFile:filePath options:NSAtomicWrite error:&error];
                
            if (error) {
                return INTERNAL_CLIENT_ERROR;
            }
            
            NSLog(@"Dowloaded flag for %@", teamName);
        }
        
    }
    return OK;
}

+ (RemoteCallResult) loadLeagues {
    // fetch all leagues
    NSURL *url = [NSURL URLWithString:leagueUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;
    
    // parse the result
    NSError *parseError = nil;
    NSArray *leagueData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    leagues = [League leaguesFromJson:leagueData];
    
    // initialize current league based on user defaults, if available
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *leagueId = [userDefaults objectForKey:LEAGUE_ID_KEY];
    if (leagueId) {
        for (League *league in leagues) {
            if (league.id == leagueId) {
                currentLeague = league;
            }
        }
    }
    
    return OK;
}

+ (UIImage*) imageForTeam:(NSString*) teamName {
    
    NSString *flagFileName = [NSString stringWithFormat:@"%@.png", teamName];
    
    // prepare the file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:flagFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        // if file already exists, simply use this
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
        return [UIImage imageWithData:imageData];
    }
    else {
        return nil;
    }
}

+ (NSMutableURLRequest*) requestForUrl:(NSString*) url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}

+ (RemoteCallResult) remoteCallResult: (NSURLResponse*) response: (NSError*) error {
    
    if (error) return INTERNAL_SERVER_ERROR;

    if (![response isKindOfClass:NSHTTPURLResponse.class]) {
        return INTERNAL_SERVER_ERROR;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
    
    switch (httpResponse.statusCode) {
        case 0:
            return NO_INTERNET;
        case 200:
            return OK;
        default:
            return INTERNAL_SERVER_ERROR;
    }
}

+ (RemoteCallResult) loadTop4 {
    NSMutableURLRequest *request = [self requestForUrl:TOP4_URL];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;
    
    // parse the result
    NSError *parseError = nil;
    NSDictionary *tipsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    top4Round = [Top4Round init:[Top4Tips fromJson:tipsData]];
    
    MatchRound *firstMatchRound = [rounds objectAtIndex:0];
    top4Round.startDate = firstMatchRound.startDate;
    top4Round.lockDate = firstMatchRound.lockDate;
    
    return OK;
}

+ (RemoteCallResult) loadScorer {
    NSURLRequest *request = [self requestForUrl:SCORER_URL];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;
    
    // parse the result
    NSError *parseError = nil;
    NSArray *tipsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    ScorerTips *scorerTips = [ScorerTips fromJson:tipsData];
    scorerRound = [ScorerRound init:scorerTips];
    
    MatchRound *firstMatchRound = [rounds objectAtIndex:0];
    scorerRound.startDate = firstMatchRound.startDate;
    scorerRound.lockDate = firstMatchRound.lockDate;
    
    return OK;
}

+ (RemoteCallResult) loadCompleteTournament {
    
    NSURLRequest *request = [self requestForUrl:ROUNDS_URL];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;    
    // parse the result
    NSError *parseError = nil;
    NSArray *roundsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    rounds = [MatchRound tournamentRoundsFromJson:roundsData];
    
    return OK;
}

+ (League*) currentLeague {
    return currentLeague;
}

+ (void) setCurrentLeague:(League*) league:(RemoteCallBlock) remoteCallBlock {
    
    if (currentLeague == league) {
        remoteCallBlock(OK);
    }
    else {
        currentLeague = league;
        
        // store selected league in user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:league.id forKey:@"leagueId"];
        [userDefaults synchronize];
        
        
        // refresh the rankings based on the selected league
        [self loadRankings:remoteCallBlock];
    }
}

+ (NSArray*) tournamentRounds {
    NSArray *staticRound = [NSArray arrayWithObjects:top4Round, scorerRound, nil];
    return [staticRound arrayByAddingObjectsFromArray:rounds];
}

+ (NSArray*) combinedTop4AndScorerRoundAndMatchRounds {
    NSArray *staticRound = [NSArray arrayWithObjects:[CompositeTop4AndScorerRound compositeRound:top4Round :scorerRound], nil];
    return [staticRound arrayByAddingObjectsFromArray:rounds];
}

+ (NSArray*) matchRounds {
    return rounds;
}

+ (NSArray*) rankings {
    return rankings;
}

+ (NSArray*) leagues {
    return leagues;
}

+ (Top4Tips*) top4 {
    return top4Round.top4Tips;
}

+ (RemoteCallResult) loadRankings {
    
    //TODO - mix in the league ID
    NSURL *url = [NSURL URLWithString:rankingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;
    
    // parse the result
    NSError *parseError = nil;
    NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    rankings = [Ranking rankingsFromJson:rankingData];
    NSLog(@"Fetched %i rankings for league %@", [rankings count], currentLeague);
    
    return OK;
}

+ (void) loadRankings:(RemoteCallBlock) remoteCallBlock {
    
    //TODO - mix in the league ID
    NSURL *url = [NSURL URLWithString:rankingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
        if (remoteCallResult != OK) {
            remoteCallBlock(remoteCallResult);
        }
        else {
            // parse the result
            NSError *parseError = nil;
            NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
            
            if (parseError) {
                remoteCallBlock(INTERNAL_CLIENT_ERROR);
            }
            
            rankings = [Ranking rankingsFromJson:rankingData];
            remoteCallBlock(OK);
        }

    }];
}

+ (void) postPrediction:(NSNumber*) matchId: (NSNumber*) firstTeamGoals: (NSNumber*) secondTeamGoals: (RemoteCallBlock) remoteCallBlock {
    
   NSMutableURLRequest *request = [self requestForUrl:BET_URL];
    
   [request setHTTPMethod:@"PUT"];
    
   // build JSON payload
   [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:
                              matchId,@"matchId",
                              firstTeamGoals,@"homeTeamGoals",
                              secondTeamGoals,@"awayTeamGoals",nil];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:kNilOptions error:&error];
    request.HTTPBody = data;
    
   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
       RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
       remoteCallBlock(remoteCallResult);
       
   }];
}

+ (void) postPredictionForPlace:(int) place andPlayer: (NSNumber*) playerId: (RemoteCallBlock) remoteCallBlock {
    NSMutableURLRequest *request = [self requestForUrl:SCORER_URL];
    
    [request setHTTPMethod:@"POST"];
    
    // build JSON payload
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:
                              playerId,@"playerId",
                              [NSNumber numberWithInt:place],@"place",
                              nil];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:kNilOptions error:&error];
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
        remoteCallBlock(remoteCallResult);

    }];
}

+ (void) postPredictionForPlace:(int) place andTeam: (NSNumber*) teamId: (RemoteCallBlock) remoteCallBlock {
    NSMutableURLRequest *request = [self requestForUrl:TOP4_URL];
    
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"Team:%i", teamId.intValue);
    
    // build JSON payload
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *jsonData = [NSDictionary dictionaryWithObjectsAndKeys:
                              teamId,@"teamId",
                              [NSNumber numberWithInt:place],@"place",
                              nil];
    
    NSLog(@"POST data %@", jsonData);
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:kNilOptions error:&error];
    request.HTTPBody = data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
        remoteCallBlock(remoteCallResult);
    }];

}

+ (RemoteCallResult) fetchTeams {
    
    NSURLRequest *request = [self requestForUrl:TEAMS_URL];
    NSError *error;
    NSURLResponse *response;
        
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RemoteCallResult remoteCallResult = [self remoteCallResult:response:error];
    if (remoteCallResult != OK) return remoteCallResult;
    
    NSError *parseError;
    NSArray *teamsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    NSLog(@"Teams: %@", teamsData);
    
    if (parseError) {
        return INTERNAL_CLIENT_ERROR;
    }
    
    [self setTeams:[Team teamsFromJson:teamsData]];
    
    return OK;
}

+ (void) setTeams:(NSArray*) allTeams {
    teams = allTeams;
    
    // create team ID to team dictionary, player list and player to player ID dictionary
    teamDictionary = [NSMutableDictionary dictionary];
    teamNames = [NSMutableDictionary dictionary];
    players = [NSMutableArray array];
    playerDictionary = [NSMutableDictionary dictionary]; 
    for (Team* team in teams) {
        
        [teamNames setObject:team forKey:team.shortName];
        [teamDictionary setObject:team forKey:team.teamId];
        
        [players addObjectsFromArray:team.players];
        
        for (Player *teamPlayer in team.players) {
            [playerDictionary setObject:teamPlayer forKey:teamPlayer.playerId];
        }
    }
}

+ (NSArray*) teamList {
    return teams;
}
    
+ (NSDictionary*) teams {
    return teamDictionary;
}

+ (NSDictionary*) teamNames {
    return teamNames;
}

+ (NSArray*) playerList {
    return players;
}

+ (NSDictionary*) players {
    return playerDictionary;
}

+ (NSString*) email {
    return userEmail;
}

+ (Top4Round*) top4Round {
    return top4Round;
}
+ (ScorerRound*) scorerRound {
    return scorerRound;
}

@end
