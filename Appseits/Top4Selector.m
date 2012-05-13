//
//  Top4Selector.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4Selector.h"
#import "BackendAdapter.h"
#import "Team.h"

@implementation Top4Selector

@synthesize team = _team;

- (void) setTeam:(Team*) team {
    _team = team;
    
    if (team) {
        self.label.text = team.name;
        self.label.textColor = [UIColor blackColor];
    }
    else {
        self.label.text = @"Välj land";
        self.label.textColor = [UIColor grayColor];
    }
    self.flag.image = team.flag;
}

@end
