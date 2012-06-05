//
//  CompetitorStatisticsViewController.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompetitorStatisticsViewController.h"
#import "UIColor+AppColors.h"
#import "ComparisonCell.h"
#import "BackendAdapter.h"
#import "Comparison.h"
#import "RoundComparison.h"

@interface CompetitorStatisticsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIView *competitorNameView;
@property (strong, nonatomic) IBOutlet UILabel *competitorNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *comparisonTable;
@property (strong, nonatomic) Comparison *comparison;
@property (strong, nonatomic) NSArray* matchComparisons;
@end

@implementation CompetitorStatisticsViewController
@synthesize scrollView;
@synthesize segmentedControl;
@synthesize competitorNameView;
@synthesize competitorNameLabel;
@synthesize comparisonTable;
@synthesize userId = _userId;
@synthesize comparison = _comparison;
@synthesize matchComparisons = _matchComparisons;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    self.competitorNameView.backgroundColor = [UIColor headerBackground];
    
    self.scrollView.contentSize = CGSizeMake(2*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.title = @"Tippade matcher";
    self.navigationItem.backBarButtonItem.title = @"Tillbaka";
    
    
    [BackendAdapter loadCompetitorComparison:self.userId :^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel vid uppdatering. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                break;
            case OK:
                self.comparison = [BackendAdapter lastComparison];
        }
    }];

}

- (void) setComparison:(Comparison *)comparison {
    _comparison = comparison;
    
    self.matchComparisons = [NSArray array];
    for (RoundComparison* roundComparison in comparison.roundComparisons) {
        
            self.matchComparisons = [self.matchComparisons arrayByAddingObjectsFromArray:roundComparison.matchComparisons]; 
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setSegmentedControl:nil];
    [self setScrollView:nil];
    [self setCompetitorNameView:nil];
    [self setCompetitorNameLabel:nil];
    [self setComparisonTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segmentedControlTapped:(id)sender {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ComparisonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparisonCell"];
    cell.matchComparison = [self.matchComparisons objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.matchComparisons count];
}

@end
