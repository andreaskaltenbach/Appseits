//
//  TimelineScrollViewRoundSection.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

#define ROUND_WIDTH 134 

@interface TimelineScrollViewRoundSection : UIView

@property (nonatomic, strong) TournamentRound *round;

+ (TimelineScrollViewRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent;

- (void) setSelected:(BOOL) selected;


@end
