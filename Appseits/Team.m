//
//  Team.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Team.h"
#import "BackendAdapter.h"

@implementation Team

@synthesize teamId = _teamId;
@synthesize name = _name;
@synthesize shortName = _shortName;
@synthesize players = _players;

+ (NSArray*) teamsFromJson:(NSArray*) teamsData {
    NSMutableArray *teams = [NSMutableArray array];
    for (NSDictionary* teamData in teamsData) {
        [teams addObject:[Team teamFromJson:teamData]];
    }
    return teams;
}

+ (Team*) teamFromJson:(NSDictionary*) teamData {
    Team* team = [[Team alloc] init];
    team.teamId = [teamData objectForKey:@"id"];
    team.name = [teamData objectForKey:@"name"];
    team.shortName = [teamData objectForKey:@"shortName"];
    
    // TODO - add players
    
    return team;
}

- (UIImage*) flag {
    return [BackendAdapter imageForTeam:self.shortName];
}

@end
