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

@protocol TeamSelectDelegate

- (void) selectTeamFor:(int) place currentSelection: (Team*) team;

@end

@interface Top4View : UIView


@property (nonatomic, strong) Top4Tips *top4Tips;
@property (nonatomic, strong) id<TeamSelectDelegate> delegate;
@end
