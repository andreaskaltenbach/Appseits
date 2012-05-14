//
//  ScorerView.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "ScorerTips.h"
#import "BackendAdapter.h"

@protocol PlayerSelectDelegate
- (void) selectPlayerFor:(int) place currentSelection: (Player*) player;
@end

@interface ScorerView : UIView

@property (nonatomic, strong) ScorerTips *scorerTips;
@property (nonatomic, strong) id<PlayerSelectDelegate> delegate;

- (void) updatePlace:(int) place withPlayer:(Player*) player: (FinishedBlock) onDone;

@end
