//
//  CompetitorStatisticsViewController.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompetitorStatisticsViewController.h"

@interface CompetitorStatisticsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CompetitorStatisticsViewController
@synthesize scrollView;
@synthesize userId = _userId;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.title = @"Tippade matcher";
    self.navigationItem.backBarButtonItem.title = @"Tillbaka";
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
