//
//  TournamentRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

@interface MatchRound : TournamentRound

@property (nonatomic, strong) NSArray *matches;

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds;

@end
