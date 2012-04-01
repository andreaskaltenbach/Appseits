//
//  TimelineScrollViewRoundSection.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

@interface TimelineScrollViewRoundSection : UIView

@property (nonatomic, strong) TournamentRound *round;

+ (TimelineScrollViewRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent;

- (void) resize:(float) offset: (float) gameWidth;

@end