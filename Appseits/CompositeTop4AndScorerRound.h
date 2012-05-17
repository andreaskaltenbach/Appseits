//
//  CompositeTop4AndScorerRound.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "ScorerRound.h"
#import "Top4Round.h"

@interface CompositeTop4AndScorerRound : TournamentRound

+ (CompositeTop4AndScorerRound*) compositeRound:(Top4Round*) top4Round:(ScorerRound*) scorerRound;

@end
