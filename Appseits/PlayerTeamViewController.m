//
//  PlayerTeamViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerTeamViewController.h"
#import "PlayerViewController.h"

@interface PlayerTeamViewController()
@property BOOL jumpedToPlayer;
@end

@implementation PlayerTeamViewController
@synthesize jumpedToPlayer = _jumpedToPlayer;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PlayerViewController *playerViewController = segue.destinationViewController;
    playerViewController.overviewViewController = self.overviewController;
    NSIndexPath *selectedRow = self.table.indexPathForSelectedRow;
    Team *selectedTeam = [self.overviewController.allTeams objectAtIndex:selectedRow.row];
    playerViewController.team = selectedTeam;
}

- (IBAction)backButtonPushed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if we selected a player previously, we jump to this player right away
    if (self.overviewController.currentPlayerSelection && !self.jumpedToPlayer) {
        self.jumpedToPlayer = YES;
        
        Team* team = self.overviewController.currentPlayerSelection.team;
        int index = [self.overviewController.allTeams indexOfObject:team];
        [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self performSegueWithIdentifier:@"toPlayerList" sender:self];
    }
}

@end
