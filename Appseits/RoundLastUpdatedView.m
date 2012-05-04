//
//  RoundLastUpdatedView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundLastUpdatedView.h"

@implementation RoundLastUpdatedView

- (void) matchesUpdated:(MatchRound*) round {
    self.label.text = [NSString stringWithFormat:@"Uppdated %@", [NSDate date]];
}

@end
