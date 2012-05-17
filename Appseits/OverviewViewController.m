//
//  OverviewViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverviewViewController.h"
#import "MatchRound.h"
#import "MatchPredictionCell.h"
#import "UIColor+AppColors.h"
#import "MatchResultCell.h"
#import "TimelineScrollView.h"
#import "Timeline.h"
#import "MatchTable.h"
#import "MenuDependendScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "RankingTable.h"
#import "Constants.h"
#import "LeaguePickerView.h"
#import "BackendAdapter.h"
#import "MainScrollView.h"
#import "PullToRefreshView.h"
#import "MatchRound.h"
#import "Top4Round.h"
#import "Top4View.h"
#import "TeamViewController.h"
#import "TeamCell.h"
#import "ScorerTips.h"
#import "ScorerRound.h"
#import "ScorerView.h"
#import "PlayerTeamCell.h"
#import "RoundTimeConstraintRow.h"
#import "SettingsViewController.h"
#import "Top4AndScorerRoundLabel.h"

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;
static UIImage *cogWheel;

@interface OverviewViewController()
@property (strong, nonatomic) IBOutlet MatchTable *gameTable;
@property (strong, nonatomic) IBOutlet TimelineScrollView *timelineScrollView;
@property (strong, nonatomic) IBOutlet LeaguePickerView *leaguePicker;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UILabel *pointInCurrentRound;
@property (strong, nonatomic) IBOutlet UILabel *pointsTotal;
@property (strong, nonatomic) IBOutlet Timeline *timeline;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *resultMenuItem;
@property (strong, nonatomic) IBOutlet UIView *rankingMenuItem;
@property (strong, nonatomic) IBOutlet MenuDependendScrollView *menuDependingScrollView;
@property (strong, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutlet UITextField *leagueInput;
@property (strong, nonatomic) IBOutlet RankingTable *rankingTable;
@property (strong, nonatomic) IBOutlet UIImageView *trendImage;
@property (strong, nonatomic) IBOutlet UIView *rankingTableHeader;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet MainScrollView *mainScrollView;
@property (nonatomic, strong) PullToRefreshView *pullToRefreshView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (strong, nonatomic) IBOutlet RoundTimeConstraintRow *roundConstraintBar;
@property (weak, nonatomic) IBOutlet Top4AndScorerRoundLabel *top4AndScorerRoundLabel;
@end

@implementation OverviewViewController
@synthesize gameTable = _gameTable;
@synthesize timelineScrollView = _timelineScrollView;
@synthesize leaguePicker = _leaguePicker;
@synthesize settingsButton = _settingsButton;
@synthesize pointInCurrentRound = _pointInCurrentRound;
@synthesize pointsTotal = _pointsTotal;
@synthesize timeline = _timeline;
@synthesize menu = _menu;
@synthesize resultMenuItem = _resultMenuItem;
@synthesize rankingMenuItem = _rankingMenuItem;
@synthesize menuDependingScrollView = _menuDependingScrollView;
@synthesize scoreView = _scoreView;
@synthesize leagueInput = _leagueInput;
@synthesize rankingTable = _rankingTable;
@synthesize trendImage = _trendImage;
@synthesize rankingTableHeader = _rankingTableHeader;
@synthesize headerView = _headerView;
@synthesize mainScrollView = _mainScrollView;
@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize separatorView = _separatorView;
@synthesize top4View = _top4View;
@synthesize scorerView = _scorerView;
@synthesize currentTeamSelection = _currentTeamSelection;
@synthesize currentTeamPlace = _currentTeamPlace;
@synthesize allTeams = _allTeams;
@synthesize currentPlayerPlace = _currentPlayerPlace;
@synthesize currentPlayerSelection = _currentPlayerSelection;
@synthesize lastUpdated = _lastUpdated;
@synthesize roundConstraintBar = _roundConstraintBar;
@synthesize top4AndScorerRoundLabel = _top4AndScorerRoundLabel;

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
    
    cogWheel = [UIImage imageNamed:@"cogwheel"];
}

- (void) scroll:(int) offset {
    self.mainScrollView.contentOffset = CGPointMake(0, self.mainScrollView.contentOffset.y + offset);
}

- (void) snapBack {
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self showInfo:@"Next level quis sartorial consequat, esse incididunt 8-bit mixtape quinoa eiusmod wes anderson. Wayfarers odio raw denim tempor non enim. Velit single-origin coffee selvage quinoa art party nihil beard, organic laborum qui."];
    
    self.lastUpdated = [NSDate date];
    
    self.pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.mainScrollView];
    self.pullToRefreshView.delegate = self;
    [self.pullToRefreshView addWatchedScrollView:self.gameTable];
    [self.pullToRefreshView addWatchedScrollView:self.rankingTable];
    
    [self.mainScrollView addSubview:self.pullToRefreshView];
    
    self.menuDependingScrollView.scrollsToTop = NO;
    
    self.headerView.backgroundColor = [UIColor headerBackground];
    self.separatorView.backgroundColor = [UIColor headerBackground];
    
    self.gameTable.scrollDelegate = self;
    self.rankingTable.scrollDelegate = self;
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeaguePicker)];
    [self.leagueInput addGestureRecognizer:tapGesture];
    
    // setup match and ranking switcher
    
    // setup of the scrollable timeline (iPhone)
    self.timelineScrollView.roundSelectDelegate = self;
    self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];

    // setup of the timeline (iPad)
    self.timeline.roundSelectDelegate = self;
    self.timeline.matchRounds = [BackendAdapter matchRounds];
    self.top4AndScorerRoundLabel.top4Round = [BackendAdapter top4Round];
    self.top4AndScorerRoundLabel.scorerRound = [BackendAdapter scorerRound];

    // setup league input
    self.leagueInput.backgroundColor = [UIColor clearColor];
    League *selectedLeague = [BackendAdapter currentLeague];
    if (selectedLeague) {
        self.leagueInput.text = selectedLeague.name;
    }
    else {
        self.leagueInput.text = @"Alla ligor";
    }
    self.leaguePicker.leagueDelegate = self;

    
    self.view.backgroundColor = [UIColor squareBackground];
    
    // initialize menu
    self.menu.backgroundColor = [UIColor menuBackground];
    self.menu.layer.shadowOffset = CGSizeMake(0, 10);
    self.menu.layer.shadowRadius = 5;
    self.menu.layer.shadowOpacity = 0.5;
    
    // initialize personal informer
    self.trendImage.image = trendUp;
    
    // setup the ranking table header
    self.rankingTableHeader.backgroundColor = [UIColor blackBackground];
    
    self.scoreView.backgroundColor = [UIColor squareBackground];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *menu = [userDefaults objectForKey:MENU_KEY];
    //TODO
    if ([menu isEqualToString:@"Ranking"]) {
        // select rankings directly
        [self rankingSelected:self];
    }
    else {
        // select match list directly
        [self resultSelected:self];
    }
    
    
    self.allTeams = [BackendAdapter teamList];
   
    // setup top4 view
    self.top4View.delegate = self;
    
    // setup scorer view
    self.scorerView.delegate = self;
        
    self.gameTable.backgroundColor = [UIColor blackBackground];
    
    
}

- (void)viewDidUnload {
    [self setTimelineScrollView:nil];
    [self setPointInCurrentRound:nil];
    [self setPointsTotal:nil];
    [self setMenu:nil];
    [self setTimeline:nil];
    [self setGameTable:nil];
    [self setMenu:nil];
    [self setResultMenuItem:nil];
    [self setRankingMenuItem:nil];
    [self setMenuDependingScrollView:nil];
    [self setScoreView:nil];
    [self setLeagueInput:nil];
    [self setLeaguePicker:nil];
    [self setRankingTable:nil];
    [self setLeaguePicker:nil];
    [self setTrendImage:nil];
    [self setRankingTableHeader:nil];
    [self setHeaderView:nil];
    [self setMainScrollView:nil];
    [self setTop4View:nil];
    [self setScorerView:nil];
    [self setSeparatorView:nil];
    [self setRoundConstraintBar:nil];
    [self setSettingsButton:nil];
    [self setTop4AndScorerRoundLabel:nil];
    [super viewDidUnload];
}

// Called whenever a tournament round is selected in the timeline
- (void) tournamentRoundSelected:(TournamentRound*) round {
    
    if (round.class == [MatchRound class]) {
        self.gameTable.round = (MatchRound*) round;
        self.top4View.hidden = YES;
        self.scorerView.hidden = YES;
        self.gameTable.hidden = NO;
    }
    if (round.class == [Top4Round class]) {
        Top4Round *top4Round = (Top4Round*) round;
        self.top4View.top4Round = top4Round;
        self.top4View.hidden = NO;
        self.scorerView.hidden = YES;
        self.gameTable.hidden = YES;
    }
    if (round.class == [ScorerRound class]) {
        ScorerRound *scorerRound = (ScorerRound*) round;
        self.scorerView.scorerRound = scorerRound;
        self.top4View.hidden = YES;
        self.scorerView.hidden = NO;
        self.gameTable.hidden = YES;
    }
    
    self.roundConstraintBar.round = round;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            return YES;
        default:
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    }
}

- (IBAction)resultSelected:(id)sender {
    NSLog(@"Result selected");
    self.rankingMenuItem.backgroundColor = [UIColor clearColor];
    self.resultMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    
    self.gameTable.scrollsToTop = YES;
    self.rankingTable.scrollsToTop = NO;
    
    [self.menuDependingScrollView scrollToMatches];
}

- (IBAction)rankingSelected:(id)sender {
    NSLog(@"Ranking selected");
    self.rankingMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    self.resultMenuItem.backgroundColor = [UIColor clearColor];
    
    self.gameTable.scrollsToTop = NO;
    self.rankingTable.scrollsToTop = YES;
    
    
    [self.menuDependingScrollView scrollToRankings];
}

- (void) showLeaguePicker {
    [self.leaguePicker show];
}

#pragma mark LeagueDelegate
- (void) leagueChanged:(League*) league {
    
    [self rankingSelected:self];
    
    if (league) {
        self.leagueInput.text = league.name;
    } else {
        self.leagueInput.text = @"Alla ligor";
    }
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    NSLog(@"refresh!");
    [BackendAdapter refreshModel:^(bool success) {
        NSLog(@"Refresh done!");
        self.lastUpdated = [NSDate date];
        [self.pullToRefreshView finishedLoading];
    }];
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return self.lastUpdated;
}

- (IBAction)logout:(id)sender {
    //[BackendAdapter logout];
    //[self.navigationController popViewControllerAnimated:YES];
}

# pragma mark TeamSelectDelegate

- (void) selectTeamFor:(int) place currentSelection: (Team*) team {
    self.currentTeamSelection = team;
    self.currentTeamPlace = place;
    self.currentPlayerSelection = nil;
    [self performSegueWithIdentifier:@"toTeamList" sender:self];
}

#pragma mark PlayerSelectDelegate
- (void) selectPlayerFor:(int) place currentSelection: (Player*) player {
    self.currentPlayerSelection = player;
    self.currentPlayerPlace = place;
    self.currentTeamSelection = nil;
    [self performSegueWithIdentifier:@"toPlayerTeamList" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTeamList"]) {
        TeamViewController *teamViewController = segue.destinationViewController;
        teamViewController.overviewController = self;
    }
    if ([segue.identifier isEqualToString:@"toPlayerTeamList"]) {
        TeamViewController *teamViewController = segue.destinationViewController;
        teamViewController.overviewController = self;
    }
    
    if ([segue.identifier isEqualToString:@"toSettings"]) {
        SettingsViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.overviewViewController = self;
    }
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamCell *teamCell = (TeamCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if (![teamCell isKindOfClass:PlayerTeamCell.class]) {
        NSLog(@"Selected %@ on place %i", teamCell.team.name, self.currentTeamPlace);
        [self updateTop4Tip:teamCell];
    }
}

- (void) updateTop4Tip:(TeamCell*) teamCell {
    [self.top4View updatePlace:self.currentTeamPlace withTeam:teamCell.team :^(bool success) {
        if (!success) {
            NSLog(@"Nothing stored!");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}


@end
