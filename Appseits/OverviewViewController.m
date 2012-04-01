//
//  OverviewViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverviewViewController.h"
#import "GameService.h"
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

@interface OverviewViewController()
@property (weak, nonatomic) IBOutlet GameTable *gameTable;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet TimelineScrollView *timelineScrollView;
@property (nonatomic, strong) NSArray *tournamentRounds;
@property (strong, nonatomic) IBOutlet UILabel *pointInCurrentRound;
@property (strong, nonatomic) IBOutlet UILabel *pointsTotal;
@property (strong, nonatomic) IBOutlet Timeline *timeline;
@property (weak, nonatomic) IBOutlet SSGradientView *menu;
@property (weak, nonatomic) IBOutlet UIView *menuItemView;
@property (weak, nonatomic) IBOutlet SSGradientView *resultMenuItem;
@property (weak, nonatomic) IBOutlet UILabel *resultMenuLabel;
@property (weak, nonatomic) IBOutlet SSGradientView *rankingMenuItem;
@property (weak, nonatomic) IBOutlet MenuDependendScrollView *menuDependingScrollView;
@property (weak, nonatomic) IBOutlet UILabel *rankingMenuLabel;
@end

@implementation OverviewViewController
@synthesize gameTable = _gameTable;
@synthesize spinner = _spinner;
@synthesize timelineScrollView = _timelineScrollView;
@synthesize tournamentRounds = _tournamentRounds;
@synthesize pointInCurrentRound = _pointInCurrentRound;
@synthesize pointsTotal = _pointsTotal;
@synthesize timeline = _timeline;
@synthesize menu = _menu;
@synthesize menuItemView = _menuItemView;
@synthesize resultMenuItem = _resultMenuItem;
@synthesize resultMenuLabel = _resultMenuLabel;
@synthesize rankingMenuItem = _rankingMenuItem;
@synthesize menuDependingScrollView = _menuDependingScrollView;
@synthesize rankingMenuLabel = _rankingMenuLabel;

- (TournamentRound*) activeRound {
    NSDate *now = [NSDate date];
    
    for (TournamentRound *round in self.tournamentRounds) {
        for (Game *game in round.games) {
            if ([now compare:game.kickOff] == NSOrderedDescending) {
                return round;
            }
        }
    }
    return nil;
}

- (int) activeRoundPoints {
    TournamentRound *activeRound = [self activeRound];
    return (activeRound) ? activeRound.points : 0;
}

- (int) totalPoints {
    int total = 0;
    for (TournamentRound *round in self.tournamentRounds) {
        total += round.points;
    }
    return total;
}

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    self.timelineScrollView.tournamentRounds = tournamentRounds;
    self.timeline.rounds = tournamentRounds;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self.spinner startAnimating];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    // initialize menu
    self.menu.colors = [UIColor menuGrayGradient];
    self.menuItemView.backgroundColor = [UIColor clearColor];
    self.resultMenuItem.backgroundColor = [UIColor clearColor];
    self.rankingMenuItem.backgroundColor = [UIColor clearColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *menu = [userDefaults objectForKey:@"menu"];
    
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
    
    self.timelineScrollView.roundSelectDelegate = self;
    self.timeline.roundSelectDelegate = self;
    
    // load matches
    [GameService getGames:^(NSArray *tournamentRounds) {
        
        // disable spinner && show table
        NSLog(@"Got matches!");
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        self.tournamentRounds = tournamentRounds;
        
    } :^(NSString *errorMessage) {
        NSLog(@"Failed to load matches!");
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
    }];
    
    self.gameTable.backgroundColor = [UIColor blackBackground];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];
}

- (void)viewDidUnload {
    [self setSpinner:nil];
    [self setTimelineScrollView:nil];
    [self setPointInCurrentRound:nil];
    [self setPointsTotal:nil];
    [self setMenu:nil];
    [self setTimeline:nil];
    [self setGameTable:nil];
    [self setMenu:nil];
    [self setMenuItemView:nil];
    [self setResultMenuItem:nil];
    [self setRankingMenuItem:nil];
    [self setResultMenuItem:nil];
    [self setRankingMenuItem:nil];
    [self setResultMenuLabel:nil];
    [self setRankingMenuLabel:nil];
    [self setMenuDependingScrollView:nil];
    [self setMenuDependingScrollView:nil];
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
    self.rankingMenuItem.colors = [UIColor menuGrayGradient];
    self.rankingMenuLabel.textColor = [UIColor blackColor];
    self.resultMenuItem.colors = [UIColor greenGradient];
    self.resultMenuLabel.textColor = [UIColor whiteColor];
    [self.menuDependingScrollView scrollToMatches];
}

- (IBAction)rankingSelected:(id)sender {
    NSLog(@"Ranking selected");
    self.rankingMenuItem.colors = [UIColor greenGradient];
    self.rankingMenuLabel.textColor = [UIColor whiteColor];
    self.resultMenuItem.colors = [UIColor menuGrayGradient];
    self.resultMenuLabel.textColor = [UIColor blackColor];
    [self.menuDependingScrollView scrollToRankings];
}


@end
