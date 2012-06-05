//
//  OverviewViewController.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"
#import "PullToRefreshView.h"
#import "ScrollTriggeringTableView.h"
#import "Top4View.h"
#import "ScorerView.h"
#import "Team.h"
#import "Player.h"
#import "AppseitsViewController.h"
#import "VersionEnforcer.h"
#import "Match.h"
#import "MatchTable.h"
#import "PlayerSelectDelegate.h"
#import "TeamSelectDelegate.h"
#import "TimelineScrollView.h"
#import "LeagueSelector.h"

@class MatchTable;
@class Top4View;
@class ScorerView;

@interface OverviewViewController : AppseitsViewController<TournamentRoundSelectDelegate, ScrollDelegate, UITableViewDelegate, PullToRefreshViewDelegate, TeamSelectDelegate, PlayerSelectDelegate, VersionDelegate, LeagueSelectionDelegate>

@property (strong, nonatomic) IBOutlet TimelineScrollView *timelineScrollView;

@property (strong, nonatomic) IBOutlet Top4View *top4View;
@property (strong, nonatomic) IBOutlet ScorerView *scorerView;
@property (strong, nonatomic) IBOutlet MatchTable *gameTable;

@property (nonatomic, strong) NSArray *allTeams;
@property (nonatomic, strong) Team *currentTeamSelection;
@property int currentTeamPlace;

@property (nonatomic, strong) Player *currentPlayerSelection;
@property int currentPlayerPlace;

@property (nonatomic, strong) Match* currentMatchSelection;

@property (nonatomic, strong) Ranking* currentRanking;

@property (strong, nonatomic) IBOutlet UIView *rankingView;
@property (strong, nonatomic) IBOutlet UIView *scoreView;

- (void) updateRankingInScoreView;

@end
