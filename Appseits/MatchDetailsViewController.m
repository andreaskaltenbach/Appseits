//
//  MatchDetailsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchDetailsViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CPTColor+AppColors.h"

@interface MatchDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (strong, nonatomic) CPTXYGraph *pieChart;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *pieChartView;

@end

@implementation MatchDetailsViewController
@synthesize scrollView = _scrollView;
@synthesize pageIndicator = _pageIndicator;
@synthesize pieChart = _pieChart;
@synthesize pieChartView = _pieChartView;



- (void)viewDidLoad
{
    
    // Create pieChart from theme
	self.pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[self.pieChart applyTheme:theme];
    
    
    self.pieChartView.hostedGraph = self.pieChart;
    
    //graphView.hostedGraph = self.pieChart;
    //[self.pieChartView setHostedGraph:self.pieChart];
    //[self.view addSubview:graphView];
    
	self.pieChart.paddingLeft   = 20.0;
	self.pieChart.paddingTop	= 20.0;
	self.pieChart.paddingRight  = 20.0;
	self.pieChart.paddingBottom = 20.0;
    
	self.pieChart.axisSet = nil;
    
	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
    
	self.pieChart.titleTextStyle = whiteText;
	//self.pieChart.title			= @"Graph Title";
    
	// Add pie chart
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource		= self;
	piePlot.pieRadius		= 60.0;
	piePlot.startAngle		= 0;
	piePlot.sliceDirection	= CPTPieDirectionCounterClockwise;
	piePlot.centerAnchor	= CGPointMake(0.5, 0.38);
	piePlot.borderLineStyle = [CPTLineStyle lineStyle];
	piePlot.delegate		= self;
	[self.pieChart addPlot:piePlot];


    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    
    CGFloat margin = self.pieChart.plotAreaFrame.borderLineStyle.lineWidth + 5.0;
    

    CGRect plotBounds	 = self.pieChart.plotAreaFrame.bounds;
    CGFloat newRadius	 = MIN(plotBounds.size.width, plotBounds.size.height) / 2.0 - margin;
    
    CGFloat y = 0.0;
    
    if ( plotBounds.size.width > plotBounds.size.height ) {
        y = 0.5;
    }
    else {
        y = (newRadius + margin) / plotBounds.size.height;
    }
    CGPoint newAnchor = CGPointMake(0.5, y);
    
    // Animate the change
    /*[CATransaction begin];
    {
        [CATransaction setAnimationDuration:1.0];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"pieRadius"];
        animation.toValue  = [NSNumber numberWithDouble:newRadius];
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [piePlot addAnimation:animation forKey:@"pieRadius"];
        
        animation		   = [CABasicAnimation animationWithKeyPath:@"centerAnchor"];
        animation.toValue  = [NSValue valueWithBytes:&newAnchor objCType:@encode(CGPoint)];
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [piePlot addAnimation:animation forKey:@"centerAnchor"];
    }
    [CATransaction commit];*/
    
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageIndicator:nil];
    [self setPieChartView:nil];
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
