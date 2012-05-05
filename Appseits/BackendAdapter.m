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

static NSString *leagueUrl;
static NSString *rankingUrl;

static NSArray *rounds;
static NSArray *rankings;
static NSArray *leagues;

static League *currentLeague;
static MatchRound *currentRound;

static NSMutableSet *matchUpdateDelegates;
static NSMutableSet *rankingUpdateDelegates;

static NSString *token;
static NSString *userName;
static NSString *userId;

static NSArray *teams;

static Top4Round *top4Round;

#define FLAG_URL @"http://img.uefa.com/imgml/flags/32x32/%@.png"

#define LOGIN_URL @"http://emtipset.dev.stendahls.se/api/login"
#define ROUNDS_URL @"http://emtipset.dev.stendahls.se/api/rounds"
#define BET_URL @"http://emtipset.dev.stendahls.se/api/bet"
#define TEAMS_URL @"http://emtipset.dev.stendahls.se/api/teams"

#define TOP4_URL @"http://dl.dropbox.com/u/15650647/top4.json"

@implementation BackendAdapter

+ (void) initialize {
    leagueUrl = @"http://dl.dropbox.com/u/15650647/leagues.json";
    rankingUrl = @"http://dl.dropbox.com/u/15650647/ranking.json";
    
    matchUpdateDelegates = [NSMutableSet set];
    rankingUpdateDelegates = [NSMutableSet set];
}

+ (void) updateMatches {
    for (id<MatchUpdateDelegate> matchUpdateDelegate in matchUpdateDelegates) {
        [matchUpdateDelegate matchesUpdated:nil];
    }
}

+ (void) updateRankings {
    for (id<RankingUpdateDelegate> rankingUpdateDelegate in rankingUpdateDelegates) {
        [rankingUpdateDelegate rankingsUpdated:nil];
    }
}

+ (void) addMatchUpdateDelegate:(id<MatchUpdateDelegate>) delegate {
    if (delegate) {
        [matchUpdateDelegates addObject:delegate];
    }
}
+ (void) addRankingUpdateDelegate:(id<RankingUpdateDelegate>) delegate {
    if (delegate) {
        [rankingUpdateDelegates addObject:delegate];
    }
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
                        [self showErrorAlert:@"No internet connection."];
                        onFinished(NO);
                    });
                    return;
                }
                
                if (response.statusCode != 401) {
                    NSLog(@"Status code: %i", response.statusCode);
                    // some unexpected has happened:
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorAlert:@"Unable to validate credentials."];
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

+ (void) initializeModel:(FinishedBlock) onFinished {
    
    dispatch_queue_t initQueue = dispatch_queue_create("initialization", NULL);

    dispatch_async(initQueue, ^{
        BOOL successRoad = [self loadCompleteTournament];
        if (successRoad) {
            successRoad = [self loadTop4];
        }
        if (successRoad) {
            successRoad = [self loadLeagues];
        
        }
        if (successRoad) {
            successRoad = [self loadRankings];
        }
        if (successRoad) {
            successRoad = [self loadFlags];
        }
        
        if (successRoad) {
            successRoad = [self fetchTeams];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            onFinished(YES);
        });
    });
}

+ (BOOL) loadFlags {
    // collect all unique team names
    NSMutableSet *teamNames = [NSMutableSet set];
    for (MatchRound *round in rounds) {
        for (Match *match in round.matches) {
            [teamNames addObject:match.firstTeamName];
            [teamNames addObject:match.secondTeamName];
        }
    }
    
    // prepare the file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *teamName in teamNames) {
        
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", teamName]];
        
        if (![fileManager fileExistsAtPath:filePath]) {
            
            // download flag from UEFA:
            NSURL *flagUrl = [NSURL URLWithString:[NSString stringWithFormat:FLAG_URL, teamName]];
            NSURLRequest* flagRequest = [NSURLRequest requestWithURL:flagUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
            NSURLResponse *response;
            NSError *error;

            NSData *flagData = [NSURLConnection sendSynchronousRequest:flagRequest returningResponse:&response error:&error];
            
            if (error) {
                NSLog(@"No flag available for %@", teamName);
            }
                
            // write flag file to disk
            [flagData writeToFile:filePath options:NSAtomicWrite error:&error];
                
            if (error) {
                [self showErrorAlert:@"Failed to store flag on file system"];
                return NO;
            }
            
            NSLog(@"Dowloaded flag for %@", teamName);
            
            
        }
        
    }
    return YES;
}

+ (BOOL) loadLeagues {
    // fetch all leagues
    NSURL *url = [NSURL URLWithString:leagueUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [self showErrorAlert:@"Error while downloading leagues"];
        return NO;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *leagueData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        [self showErrorAlert:@"Error while parsing league data from server"];
        return NO;
    }
    
    leagues = [League leaguesFromJson:leagueData];
    NSLog(@"Fetched %i leagues ", [leagues count]);
    
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
    
    return YES;
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


+ (void) showErrorAlert:(NSString*) message {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

+ (NSMutableURLRequest*) requestForUrl:(NSString*) url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    return request;
}

+ (BOOL) loadTop4 {
    NSMutableURLRequest *request = [self requestForUrl:TOP4_URL];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [self showErrorAlert:@"Error while downloading Top 4 tips"];
        return NO;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSDictionary *tipsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        [self showErrorAlert:@"Error while parsing Top 4 tips data from server"];
        return NO;
    }
    
    top4Round = [Top4Round init:[Top4Tips fromJson:tipsData]];
    NSLog(@"Fetched top 4 tips: %@", top4Round.top4Tips);
    
    return YES;
    
}

+ (BOOL) loadCompleteTournament {
    
    NSURL *url = [NSURL URLWithString:ROUNDS_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"Header: %@", token);
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [self showErrorAlert:@"Error while downloading matches"];
        return NO;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *roundsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    NSLog(@"Rounds: %@", roundsData);
    
    if (parseError) {
        [self showErrorAlert:@"Error while parsing match data from server"];
        return NO;
    }
    
    rounds = [MatchRound tournamentRoundsFromJson:roundsData];
    NSLog(@"Fetched %i tournament rounds", [rounds count]);
    
    return YES;
}

+ (League*) currentLeague {
    return currentLeague;
}

+ (void) setCurrentLeague:(League*) league:(FinishedBlock) finished {
    
    if (currentLeague == league) {
        finished(YES);
    }
    else {
        currentLeague = league;
        
        // store selected league in user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:league.id forKey:@"leagueId"];
        [userDefaults synchronize];
        
        
        // refresh the rankings based on the selected league
        [self loadRankings:finished];
    }
}

+ (NSArray*) tournamentRounds {
    NSArray *staticRound = [NSArray arrayWithObjects:top4Round, nil];
    return [staticRound arrayByAddingObjectsFromArray:rounds];
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

+ (BOOL) loadRankings {
    
    //TODO - mix in the league ID
    NSURL *url = [NSURL URLWithString:rankingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        [self showErrorAlert:@"Error while downloading rankings"];
        return YES;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        [self showErrorAlert:@"Error while parsing ranking data from server"];
        return NO;
    }
    
    rankings = [Ranking rankingsFromJson:rankingData];
    NSLog(@"Fetched %i rankings for league %@", [rankings count], currentLeague);
    
    return YES;
}

+ (void) loadRankings:(FinishedBlock) finished {
    
    //TODO - mix in the league ID
    NSURL *url = [NSURL URLWithString:rankingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"Error while downloading rankings");
            finished(NO);
        }
        else {
            // parse the result
            NSError *parseError = nil;
            NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
            
            if (parseError) {
                NSLog(@"Error while parsing ranking data from server");
                finished(NO);
            }
            
            rankings = [Ranking rankingsFromJson:rankingData];
            finished(YES);
        }
    }];
}

+ (void) postPrediction:(NSNumber*) matchId: (NSNumber*) firstTeamGoals: (NSNumber*) secondTeamGoals: (FinishedBlock) onDone {
    
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
       
   }];
}

+ (BOOL) fetchTeams {
    
    NSURLRequest *request = [self requestForUrl:TEAMS_URL];
    NSError *error;
    NSURLResponse *response;
        
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error while downloading teams");
        return NO;
    }
    NSError *parseError;
    NSArray *teamsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        [self showErrorAlert:@"Error while parsing teams from server"];
        return NO;
    }
    
    teams = [Team teamsFromJson:teamsData];
    
    NSLog(@"Fetched %i teams", [teams count]);
    
    return YES;
}

@end
