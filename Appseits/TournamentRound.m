//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "Game.h"

@implementation TournamentRound

@synthesize roundName = _roundName;
@synthesize games = _matches;
@synthesize locked = _locked;


- (int) points {
    int points = 0;
    for(Game *game in self.games) {
        points += game.points;
    }
    return points;
}

@end
