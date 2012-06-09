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

@interface UnfinishedMatchViewController ()
@property (strong, nonatomic) CPTXYGraph *pieChart;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *pieChartView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet MCSegmentedControl *segmentedControl;
@property (nonatomic, strong) MatchStatistics* matchStats;

@end

@implementation UnfinishedMatchViewController
@synthesize pieChart = _pieChart;
@synthesize pieChartView = _pieChartView;
@synthesize scrollView = _scrollView;
@synthesize segmentedControl = _segmentedControl;
@synthesize match = _match;
@synthesize matchStats = _matchStats;

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
    return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSLog(@"%f", self.matchStats.firstTeamWinPredictionPercentage.floatValue);
    
    switch (index) {
        case 0:
            return self.matchStats.secondTeamWinPredictionPercentage;
        case 1:
            return self.matchStats.drawPredictionPercentage;
        default:
            return self.matchStats.firstTeamWinPredictionPercentage;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:@"Lulu"];
	CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
	textStyle.color = [CPTColor lightGrayColor];
	label.textStyle = textStyle;
    return label;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    self.scrollView.contentSize = CGSizeMake(2*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.segmentedControl.tintColor = [UIColor segmentedControlSelected];
    self.segmentedControl.font = [UIFont boldSystemFontOfSize:12];
    
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
        }
    }];
}

- (void) setupPieChart {
        
    // points available -> create pieChart from theme
    self.pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    self.pieChartView.hostedGraph = self.pieChart;
    
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
    piePlot.pieRadius		= 120.0;
    piePlot.startAngle		= 0;
    piePlot.sliceDirection	= CPTPieDirectionClockwise;
    piePlot.centerAnchor	= CGPointMake(0.5, 0.5);
    piePlot.borderWidth = 0;
    piePlot.delegate		= self;
    
    [self.pieChart addPlot:piePlot];
    
    piePlot.labelOffset = -60;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPieChartView:nil];
    [self setScrollView:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", [self.match.firstTeam.shortName uppercaseString], [self.match.secondTeam.shortName uppercaseString]];
    
    
}


@end
