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
    // TODO - return YES if all four teams are set
    return NO;
}



@end
