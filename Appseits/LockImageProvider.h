//
//  LockImageProvider.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TournamentRound.h"

@interface LockImageProvider : NSObject

+ (UIImage*) imageForTournamentRound:(TournamentRound*) tournamentRound:(BOOL) selected;

@end
