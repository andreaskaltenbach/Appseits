//
//  ScorerSelector.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerSelector.h"

@implementation ScorerSelector

@synthesize player = _player;

- (void) setPlayer:(Player *)player {
    _player = player;
    
    if (player) {
        self.label.text = player.name;
    }
    else {
        self.label.text = @"---";
    }
    self.flag.image = player.team.flag;
}


@end
