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
    return self.scorerTips.firstPlayer && self.scorerTips.secondPlayer && self.scorerTips.thirdPlayer;
}

- (float) points {
    return self.scorerTips.firstPlayerPoints.floatValue 
    + self.scorerTips.secondPlayerPoints.floatValue
    + self.scorerTips.thirdPlayerPoints.floatValue;
}

@end
