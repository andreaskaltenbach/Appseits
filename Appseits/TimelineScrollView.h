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
@property (nonatomic, strong) TournamentRound* currentRound;

- (void) selectTournamentRound:(TournamentRound*) round;

- (void) refreshSections;

@end
