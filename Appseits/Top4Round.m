//
//  Top4Round.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4Round.h"

@implementation Top4Round

@synthesize top4Tips = _top4Tips;

+ (id) init:(Top4Tips*) top4Tips {
    
    Top4Round *round = [[Top4Round alloc] init];
    
    round.roundName = @"Top 4";
    round.top4Tips = top4Tips;
    
    return round;
}

- (BOOL) allPredictionsDone {
    return self.top4Tips.firstTeam && self.top4Tips.secondTeam && self.top4Tips.thirdTeam && self.top4Tips.fourthTeam;
}

- (float) points {
    return self.top4Tips.firstTeamPoints.floatValue 
        + self.top4Tips.secondTeamPoints.floatValue
        + self.top4Tips.thirdTeamPoints.floatValue
        + self.top4Tips.fourthTeamPoints.floatValue;
}

- (BOOL) readyToBet {
    return self.notPassed;
}

@end
