//
//  PlayerViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "UIColor+AppColors.h"
#import "PlayerCell.h"
#import "ScorerView.h"

@interface PlayerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation PlayerViewController
@synthesize table = _table;

@synthesize overviewViewController = _overviewViewController;
@synthesize team = _team;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.backgroundColor = [UIColor squareBackground];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.team.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *playerCell = @"playerCell";
    
    Player *player = [self.team.players objectAtIndex:indexPath.row];
    
    PlayerCell * cell = [tableView dequeueReusableCellWithIdentifier:playerCell];
    cell.player = player;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerCell *playerCell = (PlayerCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL allPredictionsAlreadyDone = self.overviewViewController.scorerView.scorerRound.allPredictionsDone;
    
    [self.overviewViewController.scorerView updatePlace:self.overviewViewController.currentPlayerPlace withPlayer:playerCell.player :^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Ursäkta, någonting gick fel med att spara tipset. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du är inte uppkopplad. Försök igen."];
                break;
            case OK:
                
                NSLog(@"Before: %i", allPredictionsAlreadyDone);
                NSLog(@"After: %i", self.overviewViewController.scorerView.scorerRound.allPredictionsDone);
                
                // check whether this tip was the last one to complete the scorer round
                if (!allPredictionsAlreadyDone && self.overviewViewController.scorerView.scorerRound.allPredictionsDone) {
                    [self.overviewViewController showConfirmation:@"Skyttekungsomgången är färdigtippad."];
                }
                
                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        }
    }];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we selected a player previously, we jump to this player right away
    if (self.overviewViewController.currentPlayerSelection) {
        int index = [self.team.players indexOfObject:self.overviewViewController.currentPlayerSelection];
        [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

@end
