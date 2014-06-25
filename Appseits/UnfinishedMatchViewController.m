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
#import "MCSegmentedControl.h"
#import "GANTracker.h"
#import "BackendAdapter.h"
#import "MatchStatistics.h"
#import "MatchResultDistribtion.h"
#import "CPTColor+AppColors.h"

#define BAR_HEIGHT 40

@interface UnfinishedMatchViewController ()
@property (strong, nonatomic) CPTXYGraph *pieChart;
@property (strong, nonatomic) CPTXYGraph *barChart;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *pieChartView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) MatchStatistics* matchStats;
@property (strong, nonatomic) IBOutlet UIScrollView *barChartScrollView;

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *barChartView;
@end

@implementation UnfinishedMatchViewController
@synthesize pieChart = _pieChart;
@synthesize pieChartView = _pieChartView;
@synthesize scrollView = _scrollView;
@synthesize segmentedControl = _segmentedControl;
@synthesize match = _match;
@synthesize matchStats = _matchStats;
@synthesize barChartScrollView = _barChartScrollView;
@synthesize barChart = _barChart;
@synthesize barChartView = _barChartView;

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    
    switch (index) {
        case 0:
            return [CPTFill fillWithColor:[CPTColor darkGreen]];
        case 1:
            return [CPTFill fillWithColor:[CPTColor middleDarkGreen]];
        default:
            return [CPTFill fillWithColor:[CPTColor middleLightGreen]];
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    if (plot.plotSpace.graph == self.pieChart) {
        return 3;
    }
    else {
        return [self.matchStats.resultDistribution count];
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (plot.plotSpace.graph == self.pieChart) {    
        
        switch (index) {
            case 0:
                return self.matchStats.secondTeamWinPredictionPercentage;
            case 1:
                return self.matchStats.drawPredictionPercentage;
            default:
                return self.matchStats.firstTeamWinPredictionPercentage;
        }
    }
    
    else {
        
        NSNumber *num = nil;
        
        if ( fieldEnum == CPTBarPlotFieldBarLocation ) {
            // location
            num = [NSDecimalNumber numberWithInt:index];
            
        }
        else if ( fieldEnum == CPTBarPlotFieldBarTip ) {
            // length
            MatchResultDistribtion* distribution = [self.matchStats.resultDistribution objectAtIndex:index];
            return distribution.percentage;
            
        }
        else {
            num = [NSDecimalNumber numberWithInt:0];
            
        }
        return num;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    
    if (plot.plotSpace.graph == self.pieChart) {  
        NSString* labelText;
        switch (index) {
            case 0:
                labelText = [NSString stringWithFormat:@"2\n(%.1f%%)", self.matchStats.secondTeamWinPredictionPercentage.floatValue * 100];
                break;
            case 1:
                labelText = [NSString stringWithFormat:@"X\n(%.1f%%)", self.matchStats.drawPredictionPercentage.floatValue * 100];       
                break;
            default:
                labelText = [NSString stringWithFormat:@"1\n(%.1f%%)", self.matchStats.firstTeamWinPredictionPercentage.floatValue * 100];
        }
        
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:labelText];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        
        textStyle.fontSize = 15;
        textStyle.color = [CPTColor whiteColor];
        textStyle.textAlignment = CPTTextAlignmentCenter;
        label.textStyle = textStyle;
        return label;
    }
    
    else {
        MatchResultDistribtion* distribution = [self.matchStats.resultDistribution objectAtIndex:index];
        NSString* label = [NSString stringWithFormat:@"%.1f%%", distribution.percentage.floatValue];
        return [[CPTTextLayer alloc] initWithText:label];
    }
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    self.scrollView.contentSize = CGSizeMake(2*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.segmentedControl.tintColor = [UIColor segmentedControlSelected];
    //self.segmentedControl.font = [UIFont boldSystemFontOfSize:12];
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/matchStats/%@-%@/fordelning", self.match.firstTeam.shortName, self.match.secondTeam.shortName] withError:&error];
    
    [BackendAdapter loadMatchStats:self.match.matchId :^(RemoteCallResult remoteCallResult) {
        
        switch (remoteCallResult) {
            case INTERNAL_CLIENT_ERROR:
            case INTERNAL_SERVER_ERROR:
                [self showError:@"Någonting gick fel vid uppdatering. Försök igen."];
                break;
            case NO_INTERNET:
                [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                break;
            case OK:
                self.matchStats = [BackendAdapter lastMatchStats];
                [self setupPieChart];
                [self setupBarChart];
        }
    }];
}

- (void) setupPieChart {
        
    self.pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.pieChartView.hostedGraph = self.pieChart;
    
    self.pieChart.paddingLeft   = 0.0;
    self.pieChart.paddingTop	= 0.0;
    self.pieChart.paddingRight  = 0.0;
    self.pieChart.paddingBottom = 0.0;
    
    self.pieChart.axisSet = nil;
    
    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource		= self;
    piePlot.pieRadius		= 120.0;
    piePlot.startAngle		= 0;
    piePlot.sliceDirection	= CPTPieDirectionClockwise;
    piePlot.centerAnchor	= CGPointMake(0.5, 0.5);
    piePlot.borderWidth = 0;
    piePlot.delegate		= self;
    
    [self.pieChart addPlot:piePlot];
    
    piePlot.labelOffset = -60;
    
}

- (void) setupBarChart {
    
    // height depends on amount of result predictions
    int resultPredictions = [self.matchStats.resultDistribution count];
    
    self.barChartScrollView.contentSize = CGSizeMake(self.barChartScrollView.frame.size.width, BAR_HEIGHT * resultPredictions);
    
    CPTGraph *graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, self.barChartScrollView.frame.size.width, BAR_HEIGHT * resultPredictions)];
    
    CGRect frame = self.barChartView.frame;
    frame.size.height = BAR_HEIGHT * resultPredictions;
    self.barChartView.frame = frame;
    
    self.barChartView.hostedGraph = graph;
    self.barChart.graph = graph;
    
	// get the highest percentage, defining the right border
    float max;
    int ownIndex; 
    int counter = 0;
    for (MatchResultDistribtion* resultDistribution in self.matchStats.resultDistribution) {
        max = MAX(max, resultDistribution.percentage.floatValue);
        
        if (self.match.firstTeamGoals && self.match.secondTeamGoals && self.match.firstTeamPrediction && self.match.secondTeamPrediction) {
            NSString* resultString = [NSString stringWithFormat:@"%i-%i", self.match.firstTeamPrediction.intValue, self.match.secondTeamPrediction.intValue];
            
            if ([resultString isEqualToString: resultDistribution.result]) {
                ownIndex = counter;
            }
        }
        counter++;
    }
    max+= 20;
    
    NSLog(@"Own index%i", ownIndex);
    
	// Add plot space for bar charts
	CPTXYPlotSpace *barPlotSpace = [[CPTXYPlotSpace alloc] init];
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10) length:CPTDecimalFromFloat(max)];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-5) length:CPTDecimalFromFloat([self.matchStats.resultDistribution count] + 5)];

	[graph addPlotSpace:barPlotSpace];
    
	
	// Create axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	
	CPTXYAxis *y = axisSet.yAxis;
	{
		y.majorIntervalLength		  = CPTDecimalFromInteger(1);
		y.minorTicksPerInterval		  = 0;
		y.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);

		y.preferredNumberOfMajorTicks = 8;
		y.axisLineStyle				  = nil;
		y.majorTickLineStyle		  = nil;
		y.minorTickLineStyle		  = nil;
		y.labelOffset				  = 10.0;
        
		y.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2) length:CPTDecimalFromFloat(99)];
        
        y.labelingPolicy = CPTAxisLabelingPolicyNone;
        
        // one tick location for every result prediction
        int counter = 0;
        NSMutableArray* tickLocations = [NSMutableArray arrayWithCapacity:[self.matchStats.resultDistribution count]];
        while (counter < [self.matchStats.resultDistribution count]) {
            [tickLocations addObject:[NSDecimalNumber numberWithInt:counter++]];
        }
        
        NSMutableArray *axisLabels = [NSMutableArray arrayWithCapacity:[self.matchStats.resultDistribution count]];
        for (MatchResultDistribtion* resultDistribution in self.matchStats.resultDistribution) {
            [axisLabels addObject:resultDistribution.result];
        }
		
        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[axisLabels count]];
        NSUInteger labelLocation = 0;
        for (NSNumber *tickLocation in tickLocations) {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [axisLabels objectAtIndex:labelLocation++] textStyle:y.labelTextStyle];
            newLabel.tickLocation = [tickLocation decimalValue];
            newLabel.offset = y.labelOffset + y.majorTickLength;
            
            [customLabels addObject:newLabel];
        }
        
        y.axisLabels =  [NSSet setWithArray:customLabels];

      	y.plotSpace = barPlotSpace;
	}
    
	// Set axes
	graph.axisSet.axes = [NSArray arrayWithObjects:y, nil];
    
	// Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor whiteColor];
    
	    
	CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color   = [CPTColor whiteColor];
    
	// Create bar plot
	CPTBarPlot *barPlot2 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor lightGreen] horizontalBars:NO];
    
	barPlot2.lineStyle	  = barLineStyle;
    
    barPlot2.fill		  = [CPTFill fillWithColor:[CPTColor lightGreen]];
        
	barPlot2.barBasesVary = YES;
    
	barPlot2.barWidth = CPTDecimalFromFloat(1.0f); // bar is full (100%) width
    //	barPlot2.barOffset = -0.125f; // shifted left by 12.5%
	barPlot2.barCornerRadius = 2.0f;
    
	barPlot2.barsAreHorizontal = YES;

	barPlot2.delegate	= self;
	barPlot2.dataSource = self;
	barPlot2.identifier = @"Bar Plot 2";
    
	[graph addPlot:barPlot2 toPlotSpace:barPlotSpace];
    
	
    
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPieChartView:nil];
    [self setScrollView:nil];
    [self setSegmentedControl:nil];
    [self setBarChart:nil];
    [self setBarChartView:nil];
    [self setBarChartScrollView:nil];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", [self.match.firstTeam.shortName uppercaseString], [self.match.secondTeam.shortName uppercaseString]];
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}

- (IBAction)segmentedControlTapped:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        NSError* error;
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/matchStats/%@-%@/fordelning", self.match.firstTeam.shortName, self.match.secondTeam.shortName] withError:&error];
    }
    else {
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        NSError* error;
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/matchStats/%@-%@/resultat", self.match.firstTeam.shortName, self.match.secondTeam.shortName] withError:&error];
    }
}

@end
