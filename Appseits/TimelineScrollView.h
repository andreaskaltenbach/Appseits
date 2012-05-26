//
//  TimelineScrollView.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"

@interface TimelineScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *tournamentRounds;
@property (nonatomic, strong) id<TournamentRoundSelectDelegate> roundSelectDelegate;

- (void) selectTournamentRound:(TournamentRound*) round;
@end
