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

@interface OverviewViewController()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITableView *matchTable;
@property (strong, nonatomic) IBOutlet TimelineScrollView *timelineScrollView;
@property (nonatomic, strong) NSArray *tournamentRounds;
@property (strong, nonatomic) IBOutlet UILabel *pointInCurrentRound;
@property (strong, nonatomic) IBOutlet UILabel *pointsTotal;
@property (strong, nonatomic) IBOutlet Timeline *timeline;
@property (strong, nonatomic) IBOutlet Menu *menu;
@end

@implementation OverviewViewController
@synthesize spinner;
@synthesize matchTable;
@synthesize timelineScrollView;
@synthesize tournamentRounds = _tournamentRounds;
@synthesize pointInCurrentRound;
@synthesize pointsTotal;
@synthesize timeline;
@synthesize menu;

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
    _tournamentRounds = tournamentRounds;
    
    // update score labels
    self.pointInCurrentRound.text = [NSString stringWithFormat:@"%ip", self.activeRoundPoints];
    self.pointsTotal.text = [NSString stringWithFormat:@"%ip", self.totalPoints];
    
    self.timelineScrollView.tournamentRounds = tournamentRounds;
    self.timeline.rounds = tournamentRounds;
    
    [self.matchTable reloadData];
    
    
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self.spinner startAnimating];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    // check credentials and open login view if required!
    
    
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
    
    self.matchTable.backgroundColor = [UIColor blackBackground];
    self.timelineScrollView.backgroundColor = [UIColor blackBackground];
}

- (void)viewDidUnload {
    [self setMatchTable:nil];
    [self setSpinner:nil];
    [self setTimelineScrollView:nil];
    [self setTimelineScrollView:nil];
    [self setPointInCurrentRound:nil];
    [self setPointsTotal:nil];
    [self setMenu:nil];
    [self setTimeline:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Round: %i", [self.tournamentRounds count]);
    return [self.tournamentRounds count]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TournamentRound *round = [self.tournamentRounds objectAtIndex:section];
    return [round.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gameResultCell = @"gameResultCell";
    NSString *gamePredictionCell = @"gamePredictionCell";
    
    TournamentRound *round = [self.tournamentRounds objectAtIndex:indexPath.section];
    Game *game = [round.games objectAtIndex:indexPath.row];
    
    if (round.locked) {
        GameResultCelll * cell = [tableView dequeueReusableCellWithIdentifier:gameResultCell];
        cell.game = game;
        return cell;
    }
    else {
        GamePredictionCell * cell = [tableView dequeueReusableCellWithIdentifier:gamePredictionCell];
        cell.game = game;
        return cell;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    TournamentRound *round = [self.tournamentRounds objectAtIndex:section];
    roundLabel.text = round.roundName;
    roundLabel.backgroundColor = [UIColor blackColor];
    roundLabel.textColor = [UIColor whiteColor];
    return roundLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TournamentRound *round = [self.tournamentRounds objectAtIndex:indexPath.section];
    Game *game = [round.games objectAtIndex:indexPath.row];
    
    if (round.locked) {
        return 100;
    }
    else {
        return 100;
    }
    
    
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
