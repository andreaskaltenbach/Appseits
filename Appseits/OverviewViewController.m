//
//  OverviewViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverviewViewController.h"
#import "TournamentRound.h"
#import "GamePredictionCell.h"
#import "UIColor+AppColors.h"
#import "GameResultCelll.h"
#import "TimelineScrollView.h"
#import "Game.h"
#import "Menu.h"
#import "Timeline.h"
#import "GameTable.h"
#import "MenuDependendScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "RankingTable.h"
#import "Constants.h"
#import "LeaguePickerView.h"
#import "BackendAdapter.h"
#import "MainScrollView.h"
#import "PullToRefreshView.h"

static UIImage *trendUp;
static UIImage *trendConstant;
static UIImage *trendDown;

@interface OverviewViewController()
@property (strong, nonatomic) IBOutlet GameTable *gameTable;
@property (strong, nonatomic) IBOutlet TimelineScrollView *timelineScrollView;
@property (strong, nonatomic) IBOutlet LeaguePickerView *leaguePicker;

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
@end

@implementation OverviewViewController
@synthesize gameTable = _gameTable;
@synthesize timelineScrollView = _timelineScrollView;
@synthesize leaguePicker = _leaguePicker;
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

+ (void) initialize {
    trendUp = [UIImage imageNamed:@"trendUp.png"];
    trendConstant = [UIImage imageNamed:@"trendNeutral.png"];
    trendDown = [UIImage imageNamed:@"trendDown.png"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    if (scrollView == self.gameTable || scrollView == self.rankingTable) {
        
        // if table inside the menu-dependend view is scrolled, we also scroll the main scroll view
        if (scrollView.contentOffset.y <= self.scoreView.frame.size.height) {
            self.mainScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        }
        else {
            self.mainScrollView.contentOffset = CGPointMake(0, self.scoreView.frame.size.height);
        }
        /*
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = CGPointMake(0, 0);
        scrollView.bounds = scrollBounds;*/


    }
}


- (void) viewDidLoad {
    
    self.pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.mainScrollView];
    self.pullToRefreshView.delegate = self;
    [self.pullToRefreshView addWatchedScrollView:self.gameTable];
    [self.pullToRefreshView addWatchedScrollView:self.rankingTable];
    [BackendAdapter addMatchUpdateDelegate:self.pullToRefreshView];
    [BackendAdapter addRankingUpdateDelegate:self.pullToRefreshView];
    
    [self.mainScrollView addSubview:self.pullToRefreshView];
    
    self.headerView.backgroundColor = [UIColor headerBackground];
    
    self.gameTable.scrollDelegate = self;
    self.rankingTable.scrollDelegate = self;
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeaguePicker)];
    [self.leagueInput addGestureRecognizer:tapGesture];
    
    self.timelineScrollView.roundSelectDelegate = self;
    self.timelineScrollView.tournamentRounds = [BackendAdapter tournamentRounds];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];
    self.timeline.roundSelectDelegate = self;
    self.timeline.rounds = [BackendAdapter tournamentRounds];

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
    
    
    // check credentials and open login view if required!
    

   
        
    self.gameTable.backgroundColor = [UIColor blackBackground];
    
    [super viewDidLoad];
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
    [super viewDidUnload];
}

// Called whenever a tournament round is selected in the timeline
- (void) tournamentRoundSelected:(TournamentRound*) round {
    self.gameTable.round = round;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (IBAction)resultSelected:(id)sender {
    NSLog(@"Result selected");
    self.rankingMenuItem.backgroundColor = [UIColor clearColor];
    self.resultMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    [self.menuDependingScrollView scrollToMatches];
}

- (IBAction)rankingSelected:(id)sender {
    NSLog(@"Ranking selected");
    self.rankingMenuItem.backgroundColor = [UIColor menuSelectedBackground];
    self.resultMenuItem.backgroundColor = [UIColor clearColor];
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
    [BackendAdapter updateMatches];
    [BackendAdapter updateRankings];
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    NSLog(@"view last updated!");
    return [NSDate date];
}

@end
