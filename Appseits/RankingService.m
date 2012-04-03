//
//  RankingService.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingService.h"
#import "Ranking.h"

@implementation RankingService


+ (void) getRankingsForLeague:(NSNumber*) leagueId: (RankingSuccessBlock) onSuccess: (RankingFailedBlock) onError {
    
    // fetch data in background and execute callback when data is available:
    
    NSURL *url = [NSURL URLWithString:@"http://dl.dropbox.com/u/15650647/ranking.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            onError(@"Error while downloading rankings");
        }
        else {
            // parse the result
            NSError *parseError = nil;
            NSArray *rankingData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
            
            if (parseError) {
                onError(@"Error while parsing ranking data from server");
            }
            
            NSArray *rankings = [Ranking rankingsFromJson:rankingData];
            onSuccess(rankings);
        }
        
    }];
}

@end
