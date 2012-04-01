//
//  TournamentRoundSelectDelegate.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TournamentRound.h"

@protocol TournamentRoundSelectDelegate <NSObject>

@optional
- (void) tournamentRoundSelected:(TournamentRound*) round;

@end
