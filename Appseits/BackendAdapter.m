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

@implementation BackendAdapter

+ (void) initialize {
    tournamentUrl = @"http://dl.dropbox.com/u/15650647/games.json";
    leagueUrl = @"http://dl.dropbox.com/u/15650647/leagues.json";
    rankingUrl = @"http://dl.dropbox.com/u/15650647/ranking.json";
}

+ (BOOL) validateCredentials {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"username"];
    NSString *password = [userDefaults objectForKey:@"password"];
    
    if (username && password) {
        // TODO validate credentials against backend
        return NO;
    }
    else {
        // TODO - return NO!!!
        return YES;
    }
}

+ (void) initializeModel {
    [self loadCompleteTournament];
    [self loadLeagues];
    [self loadRankings];
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



+ (void) setSelectedLeague:(League*) league {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (league) {
        [userDefaults setObject:league.name forKey:@"leagueName"];
        [userDefaults setObject:league.id forKey:@"leagueId"];
    }
    else {
        [userDefaults removeObjectForKey:@"leagueName"];
        [userDefaults removeObjectForKey:@"leagueId"];
    }
    [userDefaults synchronize];
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
