//
//  SectionSelector.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchRound.h"

@interface MatchSectionSelector : UIView

@property (nonatomic, strong) MatchRound *round;

- (void) setSelected:(BOOL) selected;

- (void) resize:(float) xOffset: (float) newWidth;

@end
