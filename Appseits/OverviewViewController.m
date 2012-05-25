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
#import "RoundSelector.h"
#import "CompositeTop4AndScorerRound.h"
#import "VersionEnforcer.h"
#import "MatchPredictionViewController.h"

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;
static UIImage *cogWheel;
static NSURL *downloadURL;

@interface OverviewViewController()
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
@property (weak, nonatomic) IBOutlet UIView *top4AndScorerView;
@property (weak, nonatomic) IBOutlet UIView *matchView;
@property (weak, nonatomic) IBOutlet RoundSelector *roundSelector;
@property (nonatomic, strong) UIPopoverController* teamPopoverController;
@property (strong, nonatomic) IBOutlet UIView *top4ContainerView;
@property (strong, nonatomic) IBOutlet UIView *scorerContainerView;
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
@synthesize top4AndScorerView = _top4AndScorerView;
@synthesize matchView = _matchView;
@synthesize roundSelector = _roundSelector;
@synthesize teamPopoverController = _teamPopoverController;
@synthesize top4ContainerView = _top4ContainerView;
@synthesize scorerContainerView = _scorerContainerView;
@synthesize currentMatchSelection = _currentMatchSelection;

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
    
    cogWheel = [UIImage imageNamed:@"cogwheel"];
    
    downloadURL = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://dl.dropbox.com/u/15650647/appseits/latest.plist"];
}

- (void) scroll:(int) offset {
    self.mainScrollView.contentOffset = CGPointMake(0, self.mainScrollView.contentOffset.y + offset);
}

- (void) snapBack {
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
}


- (void) refreshApplication {
        
    // trigger an update, if model is initialzed
    if ([BackendAdapter modelInitialized]) {
        [BackendAdapter refreshModel:^(bool success) {
            if (!success) {
                [self showError:@"Kunde tyvärr inte uppdatera"];
            }
        }];
    }
    
    // check for new app version
    VersionEnforcer *versionEnforcer = [VersionEnforcer init:self];
    [versionEnforcer checkVersion:@"http://dl.dropbox.com/u/15650647/appseits/version.json"];
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
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
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeaguePicker)];
    [self.leagueInput addGestureRecognizer:tapGesture];
    
    // setup match and ranking switcher
    
    // setup of the scrollable timeline (iPhone)
    self.timelineScrollView.roundSelectDelegate = self;
    self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];

    // setup of the timeline (iPad)
    self.timeline.matchRounds = [BackendAdapter matchRounds];
    self.roundSelector.roundSelectDelegate = self;
    self.roundSelector.tournamentRounds = [BackendAdapter combinedTop4AndScorerRoundAndMatchRounds];

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
    self.trendImage.image = trendConstant;
    
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
    self.top4AndScorerView.backgroundColor = [UIColor squareBackground];
    self.top4ContainerView.layer.cornerRadius = 10;
    self.scorerContainerView.layer.cornerRadius = 10;

    
    // setup scorer view
    self.scorerView.delegate = self;
        
    self.gameTable.backgroundColor = [UIColor blackBackground];
    
    
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
    [self setRoundSelector:nil];
    [self setTop4AndScorerView:nil];
    [self setMatchView:nil];
    [self setTop4ContainerView:nil];
    [self setScorerContainerView:nil];
    [super viewDidUnload];
}

// Called whenever a tournament round is selected in the timeline
- (void) tournamentRoundSelected:(TournamentRound*) round {
    
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
    NSLog(@"Result selected");
    self.rankingMenuItem.backgroundColor = [UIColor clearColor];
    self.resultMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    
    self.gameTable.scrollsToTop = YES;
    self.rankingTable.scrollsToTop = NO;
    
    [self.menuDependingScrollView scrollToMatches];
}

- (IBAction)rankingSelected:(id)sender {
    NSLog(@"Ranking selected");
    
    //TODO - enable ranking again, when view is ready
    /*self.rankingMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    self.resultMenuItem.backgroundColor = [UIColor clearColor];
    
    self.gameTable.scrollsToTop = NO;
    self.rankingTable.scrollsToTop = YES;
    
    
    [self.menuDependingScrollView scrollToRankings];*/
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
    [BackendAdapter refreshModel:^(bool success) {
        
        // setup of the scrollable timeline (iPhone)
        self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
        
        // setup of the timeline (iPad)
        self.timeline.matchRounds = [BackendAdapter matchRounds];
        self.roundSelector.tournamentRounds = [BackendAdapter combinedTop4AndScorerRoundAndMatchRounds];
        
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.teamPopoverController dismissPopoverAnimated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

#pragma marks VersionDelegate

- (void) updateRequired:(NSString*) versionNumber {
   
}

- (void) newVersionAvailable:(NSString*) versionNumber {
   [self showPrompt:@"Det finns en ny version av appen. Vill du ladda hem den nu?":@"Självklart!" :@"Senare" :^{
       // navigate to the download URL
       if ([[UIApplication sharedApplication] canOpenURL:downloadURL]) {
           [[UIApplication sharedApplication] openURL:downloadURL];
       }
   }];
}

@end
