//
//  PlayerTeamViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerTeamViewController.h"
#import "PlayerViewController.h"

@implementation PlayerTeamViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PlayerViewController *playerViewController = segue.destinationViewController;
    NSIndexPath *selectedRow = self.table.indexPathForSelectedRow;
    Team *selectedTeam = [self.overviewController.allTeams objectAtIndex:selectedRow.row];
    playerViewController.team = selectedTeam;
}

- (IBAction)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
