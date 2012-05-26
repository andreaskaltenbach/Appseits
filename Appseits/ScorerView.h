//
//  ScorerView.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "ScorerRound.h"
#import "BackendAdapter.h"
#import "PlayerSelectDelegate.h"
#import "OverviewViewController.h"

@class OverviewViewController;

@interface ScorerView : UIView

@property (nonatomic, strong) ScorerRound *scorerRound;
@property (nonatomic, strong) id<PlayerSelectDelegate> delegate;
@property (nonatomic, weak) OverviewViewController *overviewViewController;

- (void) updatePlace:(int) place withPlayer:(Player*) player: (RemoteCallBlock) remoteCallBlock;

@end
