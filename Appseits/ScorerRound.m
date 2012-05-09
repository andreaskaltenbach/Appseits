//
//  ScorerRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerRound.h"
#import "ScorerTips.h"

@implementation ScorerRound

@synthesize scorerTips = _scorerTips;

+ (id) init:(ScorerTips*) scorerTips {
    
    ScorerRound *round = [[ScorerRound alloc] init];
    
    round.roundName = @"Skyttekung";
    round.scorerTips = scorerTips;
    
    return round;
}

- (BOOL) allPredictionsDone {
    // TODO - return YES if all three scorers are set
    return NO;
}

@end
