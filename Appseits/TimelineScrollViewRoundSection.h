//
//  TimelineScrollViewRoundSection.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchRound.h"

#define ROUND_WIDTH 134 

@interface TimelineScrollViewRoundSection : UIView

@property (nonatomic, strong) MatchRound *round;

+ (TimelineScrollViewRoundSection*) initWithRound:(MatchRound*) round: (UIView*) parent;

- (void) setSelected:(BOOL) selected;

@end
