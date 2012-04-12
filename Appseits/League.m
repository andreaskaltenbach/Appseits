//
//  League.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "League.h"

@implementation League

@synthesize id = _id;
@synthesize name = _name;

+ (League*) league:(NSNumber*) id: (NSString*) name {
    League *league = [[League alloc] init];
    league.id = id;
    league.name = name;
    return league;
}

+ (void) getAllLeagues:(LeagueSuccessBlock) onSuccess: (LeagueFailedBlock) onError {
    
    // fetch all leagues
    NSURL *url = [NSURL URLWithString:@"http://dl.dropbox.com/u/15650647/leagues.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            onError(@"Error while downloading leagues");
        }
        else {
            // parse the result
            NSError *parseError = nil;
            NSArray *leagueData = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &parseError];
            
            if (parseError) {
                onError(@"Error while parsing league data from server");
            }
            
            NSArray *leagues = [League leaguesFromJson:leagueData];
            onSuccess(leagues);
        }
    }];
}

+ (NSArray*) leaguesFromJson:(NSArray*) jsonData {
    NSMutableArray *leagues = [NSMutableArray array];
    for (NSDictionary *leagueData in jsonData) {
        League *league = [[League alloc] init];
        league.id = [leagueData valueForKey:@"id"];
        league.name = [leagueData objectForKey:@"name"];
        [leagues addObject:league];
    }
    return leagues;
}


@end
