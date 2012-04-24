//
//  BackendAdapter.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackendAdapter.h"
#import "TournamentRound.h"
#import "Ranking.h"
#import "League.h"
#import "Constants.h"

static NSString *tournamentUrl;
static NSString *leagueUrl;
static NSString *rankingUrl;

static NSArray *rounds;
static NSArray *rankings;
static NSArray *leagues;

static League *currentLeague;
static TournamentRound *currentRound;

static NSMutableSet *matchUpdateDelegates;
static NSMutableSet *rankingUpdateDelegates;

@implementation BackendAdapter


+ (void) initialize {
    tournamentUrl = @"http://dl.dropbox.com/u/15650647/games.json";
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
    [matchUpdateDelegates addObject:delegate];
}
+ (void) addRankingUpdateDelegate:(id<RankingUpdateDelegate>) delegate {
    [rankingUpdateDelegates addObject:delegate];
}

+ (void) validateCredentials:(FinishedBlock) onFinished {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefaults objectForKey:@"email"];
    NSString *password = [userDefaults objectForKey:@"password"];
    
    if (email && password) {
        // TODO validate credentials against backend
        onFinished(YES);
    }
    else {
        // TODO - return NO!!!
        onFinished(NO);
    }
}

+ (void) initializeModel:(FinishedBlock) onFinished {
    [self loadCompleteTournament];
    [self loadLeagues];
    [self loadRankings];
    
    onFinished(YES);
}

+ (void) loadLeagues {
    // fetch all leagues
    NSURL *url = [NSURL URLWithString:leagueUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error while downloading leagues");
        return;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *leagueData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        NSLog(@"Error while parsing league data from server");
        return;
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
}

+ (void) loadCompleteTournament {
    
    NSURL *url = [NSURL URLWithString:tournamentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error while downloading matches");
        return;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *roundsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        NSLog(@"Error while parsing match data from server");
        return;
    }
    
    rounds = [TournamentRound tournamentRoundsFromJson:roundsData];
    NSLog(@"Fetched %i tournament rounds", [rounds count]);
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
    return rounds;
}

+ (NSArray*) rankings {
    return rankings;
}

+ (NSArray*) leagues {
    return leagues;
}

+ (void) loadRankings {
    
    //TODO - mix in the league ID
    NSURL *url = [NSURL URLWithString:rankingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error while downloading rankings");
        return;
    }
    
    // parse the result
    NSError *parseError = nil;
    NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
    
    if (parseError) {
        NSLog(@"Error while parsing ranking data from server");
        return;
    }
    
    rankings = [Ranking rankingsFromJson:rankingData];
    NSLog(@"Fetched %i rankings for league %@", [rankings count], currentLeague);
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

@end
