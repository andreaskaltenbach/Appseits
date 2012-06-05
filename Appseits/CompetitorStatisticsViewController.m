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
#import "MCSegmentedControl.h"

@interface CompetitorStatisticsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet MCSegmentedControl *segmentedControl;
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
    
    self.comparisonTable.backgroundColor = [UIColor clearColor];

    self.competitorNameView.backgroundColor = [UIColor headerBackground];
    
    self.scrollView.contentSize = CGSizeMake(2*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.segmentedControl.tintColor = [UIColor segmentedControlSelected];
    self.segmentedControl.font = [UIFont boldSystemFontOfSize:12];
    
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
                [self.comparisonTable reloadData];
                self.competitorNameLabel.text = [BackendAdapter lastComparison].competitorName;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.title = @"Tippade matcher";
    self.navigationItem.leftBarButtonItem.title = @"asf";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Black" style:UIBarButtonItemStyleBordered target:nil action:nil]; 
    [[self navigationItem] setBackBarButtonItem:backButton];
//    tintColor = [UIColor yellowColor];
    
    
    
}

- (void) setComparison:(Comparison *)comparison {
    _comparison = comparison;
    
    self.matchComparisons = [NSArray array];
    for (RoundComparison* roundComparison in comparison.roundComparisons) {
        
        NSLog(@"%i match rounds", [roundComparison.matchComparisons count]);
        
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
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    }
    else {
                [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ComparisonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparisonCell"];
    cell.matchComparison = [self.matchComparisons objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%i rounds", [self.matchComparisons count]);
    return [self.matchComparisons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

@end
