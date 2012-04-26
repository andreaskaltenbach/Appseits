//
//  OverviewViewController.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"
#import "LeaguePickerView.h"
#import "PullToRefreshView.h"
#import "ScrollTriggeringTableView.h"

@interface OverviewViewController : UIViewController<TournamentRoundSelectDelegate, LeagueDelegate, ScrollDelegate, UITableViewDelegate, PullToRefreshViewDelegate>
@end
