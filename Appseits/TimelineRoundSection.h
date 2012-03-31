//
//  TimelineRoundSection.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

@interface TimelineRoundSection : UIView

+ (TimelineRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent;

- (void) resize:(float) offset: (float) gameWidth;

- (void) highlight;

- (void) unhighlight;
@end
