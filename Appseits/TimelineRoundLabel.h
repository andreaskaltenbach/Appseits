//
//  TimelineRoundLabel.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

@interface TimelineRoundLabel : UIView

@property (nonatomic, strong) TournamentRound *round;
@property (nonatomic, strong) UILabel *label;

- (void) setSelected:(BOOL) selected;

- (void) resize:(float) xOffset: (float) newWidth;

@end
