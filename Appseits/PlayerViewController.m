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
#import "LightBlueGradient.h"

@interface PlayerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@end

@implementation PlayerViewController
@synthesize table = _table;
@synthesize spinner = _spinner;
@synthesize loadingView = _loadingView;

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
    [self setSpinner:nil];
    [self setLoadingView:nil];
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
    
    self.loadingView.hidden = NO;
    [self.spinner startAnimating];
    
    
    PlayerCell *playerCell = (PlayerCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL allPredictionsAlreadyDone = self.overviewViewController.scorerView.scorerRound.allPredictionsDone;
    
    [self.overviewViewController.scorerView updatePlace:self.overviewViewController.currentPlayerPlace withPlayer:playerCell.player :^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel med att spara tipset. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                break;
            case OK:
                
                [self.overviewViewController.timelineScrollView refreshSections];
                
                // check whether this tip was the last one to complete the scorer round
                if (!allPredictionsAlreadyDone && self.overviewViewController.scorerView.scorerRound.allPredictionsDone) {
                    [self.overviewViewController showConfirmation:@"Bra! Du har tippat klart dina skyttekungar."];
                }
                
                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LightBlueGradient *gradient = [[LightBlueGradient alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.table addSubview:gradient];
    
    // if we selected a player previously, we jump to this player right away
    if (self.overviewViewController.currentPlayerSelection) {
        int index = [self.team.players indexOfObject:self.overviewViewController.currentPlayerSelection];
        [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

@end
