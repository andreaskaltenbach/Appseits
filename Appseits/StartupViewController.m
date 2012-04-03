//
//  BootstrapViewControllerViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartupViewController.h"
#import "GameService.h"
#import "OverviewViewController.h"
#import "UIColor+AppColors.h"

@interface StartupViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSArray *tournamentRounds;
@end

@implementation StartupViewController
@synthesize spinner;
@synthesize tournamentRounds = _tournamentRounds;

- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner.color = [UIColor darkGreen];
	[spinner startAnimating];
    
    // check credentials and show login screen, if required
    
    
    // load tournament rounds
    [GameService getGames:^(NSArray *tournamentRounds) {
        
        NSLog(@"Got matches!");
        // forward to overview
        self.tournamentRounds = tournamentRounds;
        [self performSegueWithIdentifier:@"toOverview" sender:self];
        
    } :^(NSString *errorMessage) {
        NSLog(@"Failed to load matches!");
        [self.spinner stopAnimating];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toOverview"]) {
        OverviewViewController *overviewViewController = segue.destinationViewController;
        overviewViewController.tournamentRounds = self.tournamentRounds;
    }
}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
