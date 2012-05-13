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


@end
