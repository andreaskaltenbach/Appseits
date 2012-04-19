//
//  UnfinishedMatchViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UnfinishedMatchViewController.h"
#import "UIColor+AppColors.h"
#import "CorePlot-CocoaTouch.h"
#import "CPTColor+AppColors.h"
#import "PagedView.h"

@interface UnfinishedMatchViewController ()
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (strong, nonatomic) CPTXYGraph *pieChart;
@property (strong, nonatomic) IBOutlet UIButton *spreadButton;
@property (strong, nonatomic) IBOutlet UIButton *resultButton;
@property (strong, nonatomic) IBOutlet PagedView *scrollView;

@end

@implementation UnfinishedMatchViewController
@synthesize graphView = _graphView;
@synthesize pageIndicator = _pageIndicator;
@synthesize pieChart = _pieChart;
@synthesize spreadButton = _spreadButton;
@synthesize resultButton = _resultButton;
@synthesize scrollView = _scrollView;

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return [CPTFill fillWithColor:[CPTColor darkGreen]];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (index == 0) return [NSNumber numberWithInt:60];
    if (index == 1) return [NSNumber numberWithInt:15];
    return [NSNumber numberWithInt:25];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:@"Lulu"];
	CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
	textStyle.color = [CPTColor lightGrayColor];
	label.textStyle = textStyle;
    return label;
}

- (void)viewDidLoad
{
        
    self.view.backgroundColor = [UIColor squareBackground];
    
    
    
    [self spreadSelected:self];
    
    // Create pieChart from theme
	self.pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.graphView.hostedGraph = self.pieChart;
    
    self.pieChart.paddingLeft   = 0.0;
	self.pieChart.paddingTop	= 0.0;
	self.pieChart.paddingRight  = 0.0;
	self.pieChart.paddingBottom = 0.0;
    
	self.pieChart.axisSet = nil;
    
	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
    
	// Add pie chart
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource		= self;
	piePlot.pieRadius		= 80.0;
	piePlot.startAngle		= 0;
	piePlot.sliceDirection	= CPTPieDirectionClockwise;
	piePlot.centerAnchor	= CGPointMake(0.5, 0.5);
	piePlot.borderLineStyle = [CPTLineStyle lineStyle];
	piePlot.delegate		= self;
	[self.pieChart addPlot:piePlot];
    
    [super viewDidLoad];

}
- (IBAction)spreadSelected:(id)sender {
    self.spreadButton.selected = YES;
    self.resultButton.selected = NO;
    
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    self.pageIndicator.currentPage = 0;
    [self.scrollView selectPage:0];
}


- (IBAction)resultSelected:(id)sender {
    self.spreadButton.selected = NO;
    self.resultButton.selected = YES;
    self.pageIndicator.currentPage = 0;
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    self.pageIndicator.currentPage = 1;
    [self.scrollView selectPage:1];
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setPageIndicator:nil];
    [self setSpreadButton:nil];
    [self setResultButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
