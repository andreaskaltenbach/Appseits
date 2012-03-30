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
    
    NSURL *url = [NSURL URLWithString:@"http://dl.dropbox.com/u/15650647/games.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
       if (error) {
           onError(@"Error while downloading games");
       }
       else {
           // parse the result
           NSError *parseError = nil;
           NSArray *roundsData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
           
           if (parseError) {
               onError(@"Error while parsing match data from server");
           }
           
           NSArray *rounds = [TournamentRound tournamentRoundsFromJson:roundsData];
           onSuccess(rounds);
       }
       
    }];
}

@end
