//
//  TimelineRoundSection.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchRound.h"

@interface TimelineRoundSection : UIView

@property (nonatomic, strong) MatchRound *round;

+ (TimelineRoundSection*) initWithRound:(MatchRound*) round: (UIView*) parent;

- (void) resize:(float) xOffset: (float) newWidth;

- (void) highlight;

- (void) unhighlight;
@end
