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
#import "RoundSelector.h"
#import "CompositeTop4AndScorerRound.h"
#import "VersionEnforcer.h"
#import "MatchPredictionViewController.h"
#import "FXLabel.h"
#import "UIViewController+KNSemiModal.h"
#import "LeagueSelector.h"
#import "CompetitorStatisticsViewController.h"
#import "GANTracker.h"

#define SPINNER_DIMENSION 50

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;
static UIImage *cogWheel;
static NSURL *downloadURL;

@interface OverviewViewController()

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UILabel *pointInCurrentRound;
@property (strong, nonatomic) IBOutlet UILabel *pointsTotal;
@property (strong, nonatomic) IBOutlet Timeline *timeline;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *resultMenuItem;
@property (strong, nonatomic) IBOutlet UIView *rankingMenuItem;
@property (strong, nonatomic) IBOutlet MenuDependendScrollView *menuDependingScrollView;
@property (strong, nonatomic) IBOutlet RankingTable *rankingTable;
@property (strong, nonatomic) IBOutlet UIImageView *trendImage;
@property (strong, nonatomic) IBOutlet UIView *rankingTableHeader;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet MainScrollView *mainScrollView;
@property (nonatomic, strong) PullToRefreshView *pullToRefreshView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (strong, nonatomic) IBOutlet RoundTimeConstraintRow *roundConstraintBar;
@property (weak, nonatomic) IBOutlet UIView *top4AndScorerView;
@property (weak, nonatomic) IBOutlet UIView *matchView;
@property (weak, nonatomic) IBOutlet RoundSelector *roundSelector;
@property (nonatomic, strong) UIPopoverController* teamPopoverController;
@property (strong, nonatomic) IBOutlet UIView *top4ContainerView;
@property (strong, nonatomic) IBOutlet UIView *scorerContainerView;
@property (strong, nonatomic) IBOutlet FXLabel *tipsMenu;
@property (strong, nonatomic) IBOutlet FXLabel *rankingMenu;
@property (strong, nonatomic) IBOutlet UIView *rankingMenuView;
@property (strong, nonatomic) IBOutlet LeagueSelector *leagueSelector;
@property (strong, nonatomic) IBOutlet UITableView *leagueTable;
@property (strong, nonatomic) IBOutlet UIImageView *dropDownIndicator;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalRanks;
@property (strong, nonatomic) IBOutlet UILabel *rankSeparator;
@property (nonatomic, strong) League* currentLeague;
@property (nonatomic, strong) UIView *loadingView;
@property (strong, nonatomic) IBOutlet YellowBar *lastRankingUpdateBar;

@end

@implementation OverviewViewController
@synthesize gameTable = _gameTable;
@synthesize timelineScrollView = _timelineScrollView;
@synthesize settingsButton = _settingsButton;
@synthesize pointInCurrentRound = _pointInCurrentRound;
@synthesize pointsTotal = _pointsTotal;
@synthesize timeline = _timeline;
@synthesize menu = _menu;
@synthesize resultMenuItem = _resultMenuItem;
@synthesize rankingMenuItem = _rankingMenuItem;
@synthesize menuDependingScrollView = _menuDependingScrollView;
@synthesize scoreView = _scoreView;
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
@synthesize top4AndScorerView = _top4AndScorerView;
@synthesize matchView = _matchView;
@synthesize roundSelector = _roundSelector;
@synthesize teamPopoverController = _teamPopoverController;
@synthesize top4ContainerView = _top4ContainerView;
@synthesize scorerContainerView = _scorerContainerView;
@synthesize tipsMenu = _tipsMenu;
@synthesize rankingMenu = _rankingMenu;
@synthesize rankingMenuView = _rankingMenuView;
@synthesize leagueSelector = _leagueSelector;
@synthesize leagueTable = _leagueTable;
@synthesize dropDownIndicator = _dropDownIndicator;
@synthesize rankLabel = _rankLabel;
@synthesize totalRanks = _totalRanks;
@synthesize rankSeparator = _rankSeparator;
@synthesize rankingView = _rankingView;
@synthesize currentMatchSelection = _currentMatchSelection;
@synthesize currentLeague = _currentLeague;
@synthesize currentRanking = _currentRanking;
@synthesize loadingView = _loadingView;
@synthesize lastRankingUpdateBar = _lastRankingUpdateBar;

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
    
    cogWheel = [UIImage imageNamed:@"cogwheel"];
    
    downloadURL = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://em2012.brunoson.se/app/emtipset.plist"];
}

- (void) scroll:(int) offset {
    self.mainScrollView.contentOffset = CGPointMake(0, self.mainScrollView.contentOffset.y + offset);
}

- (void) snapBack {
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
}

- (void) refreshApplication {
        
    // trigger a model update
    [BackendAdapter refreshModel:^(RemoteCallResult remoteCallResult) {
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel vid uppdatering. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök att ladda om genom att dra nedåt."];
                break;
            case OK:
                // update of the scrollable timeline (iPhone)
                self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
                
                // update of the timeline (iPad)
                self.timeline.matchRounds = [BackendAdapter matchRounds];
                self.roundSelector.tournamentRounds = [BackendAdapter combinedTop4AndScorerRoundAndMatchRounds];
        }
    }];
    
    // check for new app version
    VersionEnforcer *versionEnforcer = [VersionEnforcer init:self];
    [versionEnforcer checkVersion:@"http://em2012.brunoson.se/app/version.json"];
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackBackground];
    
    // check for new app version
    VersionEnforcer *versionEnforcer = [VersionEnforcer init:self];
    [versionEnforcer checkVersion:@"http://em2012.brunoson.se/app/version.json"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshApplication)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.lastUpdated = [NSDate date];
    
    self.pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.mainScrollView];
    self.pullToRefreshView.delegate = self;
    [self.pullToRefreshView addWatchedScrollView:self.gameTable];
    [self.pullToRefreshView addWatchedScrollView:self.rankingTable];
    
    [self.mainScrollView addSubview:self.pullToRefreshView];
    
    self.menuDependingScrollView.scrollsToTop = NO;
    
    self.headerView.backgroundColor = [UIColor headerBackground];
    self.separatorView.backgroundColor = [UIColor headerBackground];
    
    self.gameTable.overviewViewController = self;
    self.gameTable.scrollDelegate = self;
    self.rankingTable.scrollDelegate = self;
    self.rankingTable.overviewViewController = self;
        
    // setup of the scrollable timeline (iPhone)
    self.timelineScrollView.roundSelectDelegate = self;
    self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];

    // setup of the timeline (iPad)
    self.timeline.matchRounds = [BackendAdapter matchRounds];
    self.roundSelector.roundSelectDelegate = self;
    self.roundSelector.tournamentRounds = [BackendAdapter combinedTop4AndScorerRoundAndMatchRounds];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    // initialize menu
    self.menu.backgroundColor = [UIColor menuBackground];
    self.menu.layer.shadowOffset = CGSizeMake(0, 4);
    self.menu.layer.shadowRadius = 2;
    self.menu.layer.shadowOpacity = 0.3;
    
    self.tipsMenu.shadowColor = nil;
    self.tipsMenu.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.tipsMenu.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.tipsMenu.shadowBlur = 5.0f;
    
    self.rankingMenu.shadowColor = nil;
    self.rankingMenu.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.rankingMenu.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.rankingMenu.shadowBlur = 5.0f;
    
    [self.rankingMenuView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchLeague)]];

    // initialize personal informer
    self.trendImage.image = trendConstant;
    
    // setup the ranking table header
    self.rankingTableHeader.backgroundColor = [UIColor blackBackground];
    
    self.scoreView.backgroundColor = [UIColor squareBackground];
    
    self.allTeams = [BackendAdapter teamList];
   
    // setup top4 view
    self.top4View.delegate = self;
    self.top4View.overviewViewController = self;
    self.top4AndScorerView.backgroundColor = [UIColor squareBackground];
    self.top4ContainerView.layer.cornerRadius = 10;
    self.scorerContainerView.layer.cornerRadius = 10;

    
    // setup scorer view
    self.scorerView.delegate = self;
    self.scorerView.overviewViewController = self;
        
    self.gameTable.backgroundColor = [UIColor blackBackground];
    
    // setup league selector
    [self refreshRankingLabel];
    self.leagueSelector.leagueSelectionDelegate = self;
    [self.leagueSelector selectCurrentLeague];
    
    [self updateRankingInScoreView];
    [self.rankingTable scrollToMyself];
    [self updateLastRankingUpdateLabel];
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:@"app/overview" withError:&error];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *menu = [userDefaults objectForKey:MENU_KEY];
    if ([menu isEqualToString:@"RANKING"]) {
        // select rankings directly
        [self switchToRanking];
    }
    else {
        // select match list directly
        [self resultSelected:self];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    [self setRankingTable:nil];
    [self setTrendImage:nil];
    [self setRankingTableHeader:nil];
    [self setHeaderView:nil];
    [self setMainScrollView:nil];
    [self setTop4View:nil];
    [self setScorerView:nil];
    [self setSeparatorView:nil];
    [self setRoundConstraintBar:nil];
    [self setSettingsButton:nil];
    [self setRoundSelector:nil];
    [self setTop4AndScorerView:nil];
    [self setMatchView:nil];
    [self setTop4ContainerView:nil];
    [self setScorerContainerView:nil];
    [self setTipsMenu:nil];
    [self setRankingMenu:nil];
    [self setRankingMenuView:nil];
    [self setLeagueSelector:nil];
    [self setLeagueTable:nil];
    [self setDropDownIndicator:nil];
    [self setRankingView:nil];
    [self setRankLabel:nil];
    [self setRankSeparator:nil];
    [self setTotalRanks:nil];
    [self setRankSeparator:nil];
    [self setLastRankingUpdateBar:nil];
    [super viewDidUnload];
}

- (void) switchLeague {
    if ([[BackendAdapter leagues] count] > 0) {
        // show league selector, if user has at least one league
        [self presentSemiView:self.leagueSelector];
    }
    else {
        // otherwise, we jump to the super league directly
        [self switchToRanking];
    }
}

// Called whenever a tournament round is selected in the timeline
- (void) tournamentRoundSelected:(TournamentRound*) round {
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/round/%@", round.roundName] withError:&error];
    
    // iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (round.class == [MatchRound class]) {
            self.gameTable.round = (MatchRound*) round;
            self.top4AndScorerView.hidden = YES;
            self.matchView.hidden = NO;
        }
        if (round.class == [CompositeTop4AndScorerRound class]) {
            CompositeTop4AndScorerRound *compositeRound = (CompositeTop4AndScorerRound*) round;
            self.top4AndScorerView.hidden = NO;
            self.matchView.hidden = YES;
            self.top4View.top4Round = compositeRound.top4Round;
            self.scorerView.scorerRound = compositeRound.scorerRound;
        }
    }

    // iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
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
    }
    
    self.roundConstraintBar.round = round;
    self.roundConstraintBar.overviewViewController = self;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;

    self.pointInCurrentRound.text = [NSString stringWithFormat:@"%@p", [formatter stringFromNumber:[NSNumber numberWithFloat:round.points]]];
    self.pointsTotal.text = [NSString stringWithFormat:@"%@p", [formatter stringFromNumber:[NSNumber numberWithFloat:[TournamentRound totalPoints]]]];
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
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:@"app/overview/tips" withError:&error];
    
    // store menu selection on client side
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"TIPS" forKey:MENU_KEY];
    [userDefaults synchronize];
    
    self.rankingMenuItem.backgroundColor = [UIColor clearColor];
    self.resultMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    
    self.gameTable.scrollsToTop = YES;
    self.rankingTable.scrollsToTop = NO;
    
    [self.menuDependingScrollView scrollToMatches];
}

- (void) switchToRanking {
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:@"app/overview/ranking" withError:&error];
    
    // store menu selection on client side
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"RANKING" forKey:MENU_KEY];
    [userDefaults synchronize];
    
    self.rankingMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    self.resultMenuItem.backgroundColor = [UIColor clearColor];
    
    self.gameTable.scrollsToTop = NO;
    self.rankingTable.scrollsToTop = YES;
    [self.menuDependingScrollView scrollToRankings];
    
    [self loadRankings];
}

- (void) loadRankings {
    
    if (self.currentLeague != BackendAdapter.currentLeague) {
        self.currentLeague = BackendAdapter.currentLeague;
        
        self.loadingView.hidden = NO;
        
        [BackendAdapter loadRankings:^(RemoteCallResult remoteResult) {
            
            switch (remoteResult) {
                case INTERNAL_CLIENT_ERROR:
                case INTERNAL_SERVER_ERROR:
                    [self showError:@"Någonting gick fel. Försök igen."];
                    break;
                case NO_INTERNET:
                    [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                    break;
                    
                case OK:
                    
                    [self updateRankingInScoreView]; 
                    [self.rankingTable refreshRankings];
                    break;
                    
            }
            self.loadingView.hidden = YES;
        }];
    }

}

- (UIView*) loadingView {
    if (!_loadingView) {;
        
        _loadingView = [[UIView alloc] initWithFrame:self.rankingView.bounds];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _loadingView.backgroundColor = [UIColor whiteColor];
        _loadingView.alpha = 0.6;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.rankingView.bounds.size.width/2 - SPINNER_DIMENSION/2, self.rankingView.bounds.size.height/2 - SPINNER_DIMENSION/2, SPINNER_DIMENSION, SPINNER_DIMENSION)];
        spinner.color = [UIColor darkGreen];
        spinner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
        [self.rankingView addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [BackendAdapter refreshModel:^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel. Försök att ladda om genom att dra nedåt."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök att ladda om genom att dra nedåt."];
                break;
            case OK:
                // update of the scrollable timeline (iPhone)
                self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
                
                // update of the timeline (iPad)
                self.timeline.matchRounds = [BackendAdapter matchRounds];
                self.roundSelector.tournamentRounds = [BackendAdapter combinedTop4AndScorerRoundAndMatchRounds];
                
                // update the score view
                [self updateRankingInScoreView];
                
                // update the ranking view
                [self.rankingTable refreshRankings];
                [self updateLastRankingUpdateLabel];
        }
        
        self.lastUpdated = [NSDate date];
        [self.pullToRefreshView finishedLoading];
    }];
}

- (void) updateLastRankingUpdateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [formatter setDateFormat:@"yyyy-MM-dd HH.mm"];
    self.lastRankingUpdateBar.label.text = [NSString stringWithFormat:@"Uppdaterad: %@", [formatter stringFromDate:self.lastUpdated]];

}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return self.lastUpdated;
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
        
        TeamViewController *teamViewController; 
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *navController = segue.destinationViewController;
            teamViewController = [navController.viewControllers objectAtIndex:0];
            UIStoryboardPopoverSegue* popSegue = (UIStoryboardPopoverSegue*) segue;
            self.teamPopoverController = popSegue.popoverController;
        }
        else {
            teamViewController = segue.destinationViewController;
        }
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
    
    if ([segue.identifier isEqualToString:@"toMatchPrediction"]) {
        MatchPredictionViewController *matchPredictionController = segue.destinationViewController;
        matchPredictionController.match = self.currentMatchSelection;
        matchPredictionController.overviewViewController = self;
    }
    
    if ([segue.identifier isEqualToString:@"toCompetitorStatistic"]) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Tillbaka" style:UIBarButtonItemStylePlain target:nil action:nil];
        backButton.tintColor = [UIColor backButtonColor];
        [[self navigationItem] setBackBarButtonItem:backButton];
        CompetitorStatisticsViewController *statisticsController = segue.destinationViewController;
        statisticsController.ranking = self.currentRanking;
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
    
    BOOL allPredictionsAlreadyDone = self.top4View.top4Round.allPredictionsDone;
    
    [self.top4View updatePlace:self.currentTeamPlace withTeam:teamCell.team :^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel med att spara tipset. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                break;
            case OK:
                
                [self.timelineScrollView refreshSections];
                
                // check whether this tip was the last one to complete the top 4 round
                if (!allPredictionsAlreadyDone && self.top4View.top4Round.allPredictionsDone) {
                    [self showConfirmation:@"Bra! Du har tippat klart Topp 4."];
                }
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self.teamPopoverController dismissPopoverAnimated:YES];
                }
        }
    }];
}

#pragma marks VersionDelegate

- (void) updateRequired:(NSString*) versionNumber {
   
}

- (void) newVersionAvailable:(NSString*) versionNumber {
   [self showPrompt:@"Det finns en ny version av appen!":@"Ladda hem nu" :@"Senare" :^{
       
       NSError* error;
       NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
       [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/update/%@", appVersion] withError:&error];
       
       // navigate to the download URL
       if ([[UIApplication sharedApplication] canOpenURL:downloadURL]) {
           [[UIApplication sharedApplication] openURL:downloadURL];
       }
   }];
}

- (void) refreshRankingLabel {
    NSString* leagueName = [BackendAdapter currentLeague].name;
    if (!leagueName) {
        leagueName = @"Alla deltagare";
    }
    
    // define width of text
    float width = [leagueName sizeWithFont:[UIFont boldSystemFontOfSize:15]].width;
    CGRect rankingItemFrame = self.rankingMenuItem.frame;
    rankingItemFrame.size.width = width + 55;
    self.rankingMenuItem.frame = rankingItemFrame;
    
    // update ranking menu item text
    self.rankingMenu.text = leagueName;
}

# pragma marks LeagueSelectorDelegate

- (void) leagueSelected:(League*) league {
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/league/%@", league.name] withError:&error];
    
    [BackendAdapter setCurrentLeague:league];
    
    // update ranking label
    [self refreshRankingLabel];
    
    [self dismissSemiModalView];
       
    // switch to ranking view
    [self switchToRanking];
}

- (void) updateRankingInScoreView {
    NSString* rank = [NSString stringWithFormat:@"%i",BackendAdapter.myRanking.rank.intValue];
    NSString* allRankings = [NSString stringWithFormat:@"%i",[[BackendAdapter rankings] count]];
    
    UIFont* font = [UIFont systemFontOfSize:30];
    
    self.rankLabel.text = rank;
    CGSize rankSize = [rank sizeWithFont:font];
    CGRect frame = self.rankLabel.frame;
    frame.size.width = rankSize.width;
    self.rankLabel.frame = frame;
    
    frame = self.rankSeparator.frame;
    frame.origin.x = self.rankLabel.frame.origin.x + self.rankLabel.frame.size.width;
    self.rankSeparator.frame = frame;
    

    self.totalRanks.text = allRankings;
    frame = self.totalRanks.frame;
    frame.origin.x = self.rankSeparator.frame.origin.x + self.rankSeparator.frame.size.width;
    CGSize totalRanksSize = [allRankings sizeWithFont:font];
    frame.size.width = totalRanksSize.width;
    self.totalRanks.frame = frame;
}

@end
