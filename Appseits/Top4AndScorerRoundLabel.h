//
//  Top4AndScorerRoundLabel.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineRoundLabel.h"
#import "Top4Round.h"
#import "ScorerRound.h"

@interface Top4AndScorerRoundLabel : TimelineRoundLabel

@property (nonatomic, strong) Top4Round *top4Round;
@property (nonatomic, strong) ScorerRound *scorerRound;

@end
