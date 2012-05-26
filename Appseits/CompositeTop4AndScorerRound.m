//
//  CompositeTop4AndScorerRound.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompositeTop4AndScorerRound.h"
#import "ScorerRound.h"
#import "Top4Round.h"

@implementation CompositeTop4AndScorerRound

@synthesize top4Round = _top4Round;
@synthesize scorerRound = _scorerRound;

+ (CompositeTop4AndScorerRound*) compositeRound:(Top4Round*) top4Round:(ScorerRound*) scorerRound {
    CompositeTop4AndScorerRound *round = [[CompositeTop4AndScorerRound alloc] init];
    round.top4Round = top4Round;
    round.scorerRound = scorerRound;
    round.roundName = @"Top4 & Skyttekung";
    return round;
}

- (float) points {
    return self.top4Round.points + self.scorerRound.points;
}

- (BOOL) open {
    return self.top4Round.open;
}

- (BOOL) allPredictionsDone {
    return self.top4Round.allPredictionsDone && self.scorerRound.allPredictionsDone;
}

- (BOOL) readyToBet {
    return self.top4Round.readyToBet && self.scorerRound.readyToBet;
}

@end
