//
//  OverviewViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverviewViewController.h"
#import "MatchService.h"
#import "TournamentRound.h"
#import "MatchCell.h"

@interface OverviewViewController()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITableView *matchTable;
@property (nonatomic, strong) NSArray *tournamentRounds;
@end

@implementation OverviewViewController
@synthesize spinner;
@synthesize matchTable;
@synthesize tournamentRounds = _tournamentRounds;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self.spinner startAnimating];
    
    // check credentials and open login view if required!
    
    
    // load matches
    [MatchService getMatches:^(NSArray *tournamentRounds) {
        
        // disable spinner && show table
        NSLog(@"Got matches!");
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        self.tournamentRounds = tournamentRounds;
        [self.matchTable reloadData];
        
    } :^(NSString *errorMessage) {
        NSLog(@"Failed to load matches!");
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
    }];
}

- (void)viewDidUnload {
    [self setMatchTable:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"Round: %i", [self.tournamentRounds count]);
    return [self.tournamentRounds count]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TournamentRound *round = [self.tournamentRounds objectAtIndex:section];
    return [round.matches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell"];

    TournamentRound *round = [self.tournamentRounds objectAtIndex:indexPath.section];
    Match *match = [round.matches objectAtIndex:indexPath.row];
    
    cell.match = match;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    TournamentRound *round = [self.tournamentRounds objectAtIndex:section];
    roundLabel.text = round.roundName;
    roundLabel.backgroundColor = [UIColor blackColor];
    roundLabel.textColor = [UIColor whiteColor];
    return roundLabel;
}

@end
