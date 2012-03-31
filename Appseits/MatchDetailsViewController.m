//
//  MatchDetailsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchDetailsViewController.h"

@interface MatchDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicator;

@end

@implementation MatchDetailsViewController
@synthesize scrollView;
@synthesize pageIndicator;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, scrollView.frame.size.height);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)viewTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
