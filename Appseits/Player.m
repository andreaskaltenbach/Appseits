//
//  Player.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Team.h"

@implementation Player

@synthesize team = _team;
@synthesize playerId = _playerId;
@synthesize name = _name;

+ (NSArray*) playersFromJson:(NSArray*) jsonData forTeam:(Team*) team {
    NSMutableArray *players = [NSMutableArray array];
    for (NSArray *playerData in jsonData) {
        [players addObject:[self playersFromJson:playerData forTeam:team]];
    }
    return players;
}

+ (Player*) playerFromJson:(NSDictionary*) jsonData forTeam:(Team*) team {
    Player *player = [[Player alloc] init];
    player.playerId = [jsonData valueForKey:@"playerId"];
    player.name = [jsonData valueForKey:@"name"];
    
    player.team = team;
    
    return player;
}

@end
