//
//  League.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "League.h"

@implementation League

@synthesize leagueId = _leagueId;
@synthesize name = _name;

+ (League*) league:(NSNumber*) leagueId: (NSString*) name {
    League *league = [[League alloc] init];
    league.leagueId = leagueId;
    league.name = name;
    return league;
}

+ (NSArray*) leaguesFromJson:(NSArray*) jsonData {
    NSMutableArray *leagues = [NSMutableArray array];
    for (NSDictionary *leagueData in jsonData) {
        League *league = [[League alloc] init];
        league.leagueId = [leagueData valueForKey:@"id"];
        NSLog(@"league ID %i", league.leagueId.intValue);
        league.name = [leagueData objectForKey:@"name"];
        [leagues addObject:league];
    }
    NSLog(@"%i", [leagues count]);
    return leagues;
}


@end
