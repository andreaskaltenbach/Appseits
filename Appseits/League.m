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
