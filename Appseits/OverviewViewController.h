//
//  OverviewViewController.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"
#import "LeaguePicker.h"

@interface OverviewViewController : UIViewController<TournamentRoundSelectDelegate, LeaguePickDelegate>
@property (nonatomic, strong) NSArray *tournamentRounds;
@end
