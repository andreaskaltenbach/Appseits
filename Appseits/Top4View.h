//
//  Top4View.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Top4Tips.h"
#import "Team.h"
#import "BackendAdapter.h"

#define Y_OFFSET 5
#define MARGIN 60

@protocol TeamSelectDelegate

- (void) selectTeamFor:(int) place currentSelection: (Team*) team;

@end

@interface Top4View : UIView


@property (nonatomic, strong) Top4Tips *top4Tips;
@property (nonatomic, strong) id<TeamSelectDelegate> delegate;

- (void) updatePlace:(int) place withTeam:(Team*) team: (FinishedBlock) onDone;

@end
