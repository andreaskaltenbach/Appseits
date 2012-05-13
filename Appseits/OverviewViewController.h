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
#import "Top4View.h"
#import "ScorerView.h"
#import "Team.h"
#import "Player.h"

@interface OverviewViewController : UIViewController<TournamentRoundSelectDelegate, LeagueDelegate, ScrollDelegate, UITableViewDelegate, PullToRefreshViewDelegate, TeamSelectDelegate, PlayerSelectDelegate>

@property (nonatomic, strong) NSArray *allTeams;
@property (nonatomic, strong) Team *currentTeamSelection;
@property int currentTeamPlace;

@property (nonatomic, strong) Player *currentPlayerSelection;
@property int currentPlayerPlace;

@end
