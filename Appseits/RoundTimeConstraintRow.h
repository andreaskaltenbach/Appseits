//
//  LastUpdateView.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YellowBar.h"
#import "TournamentRound.h"

@class OverviewViewController;

@interface RoundTimeConstraintRow : YellowBar

@property (nonatomic, strong) TournamentRound *round;
@property (nonatomic, weak) OverviewViewController *overviewViewController;

@end
