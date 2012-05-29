//
//  Top4View.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Top4Round.h"
#import "Team.h"
#import "BackendAdapter.h"
#import "OverviewViewController.h"
#import "TeamSelectDelegate.h"

#define Y_OFFSET 5
#define MARGIN 55

@class OverviewViewController;


@interface Top4View : UIView


@property (nonatomic, strong) Top4Round *top4Round;
@property (nonatomic, strong) id<TeamSelectDelegate> delegate;
@property (nonatomic, weak) OverviewViewController *overviewViewController;

- (void) updatePlace:(int) place withTeam:(Team*) team: (RemoteCallBlock) remoteCallBlock;

@end
