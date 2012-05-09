//
//  ScorerRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TournamentRound.h"
#import "ScorerTips.h"

@interface ScorerRound : TournamentRound

@property (nonatomic, strong) ScorerTips *scorerTips;

+ (id) init:(ScorerTips*) scorerTips;

@end
