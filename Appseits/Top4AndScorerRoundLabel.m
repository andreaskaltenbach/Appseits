//
//  Top4AndScorerRoundLabel.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4AndScorerRoundLabel.h"

@implementation Top4AndScorerRoundLabel

@synthesize top4Round = _top4Round;
@synthesize scorerRound = _scorerRound;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setRound:(TournamentRound *)round {
    self.label.text = @"TOP 4 & SKYTTEKUNG";
}

- (void) setScorerRound:(ScorerRound *)scorerRound {
    self.round = scorerRound;
}

@end
