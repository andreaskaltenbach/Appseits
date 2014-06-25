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
#import "CorePlot-CocoaTouch.h"
#import "CPTColor+AppColors.h"
#import "CompetitorStatisticCell.h"
#import "ScorerPredictionResult.h"
#import "Top4PredictionResult.h"
#import "GANTracker.h"

#define SK @"SK"
#define T4 @"T4"
#define _1X2 @"1X2"
#define AMP_AMP @"?-?"

@interface CompetitorStatisticsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *comparisonTable;
@property (strong, nonatomic) Comparison *comparison;
@property (strong, nonatomic) NSArray* matchComparisons;
@property (strong, nonatomic) CPTXYGraph* pieChart;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;
@property (strong, nonatomic) NSMutableDictionary *pointsDict;
@property (strong, nonatomic) NSMutableDictionary *indexToPointsDict;
@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UITableView *teamTable;
@property (strong, nonatomic) IBOutlet UILabel *noPointsYetLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *statisticView;
@property (strong, nonatomic) IBOutlet UIView *top4AndScorerView;
@end

@implementation CompetitorStatisticsViewController
@synthesize scrollView;
@synthesize segmentedControl;
@synthesize comparisonTable;
@synthesize comparison = _comparison;
@synthesize matchComparisons = _matchComparisons;
@synthesize pieChart = _pieChart;
@synthesize graphView;
@synthesize ranking = _ranking;
@synthesize pointsDict = _pointsDict;
@synthesize indexToPointsDict = _indexToPointsDict;
@synthesize playerTable;
@synthesize teamTable;
@synthesize noPointsYetLabel;
@synthesize statisticView;
@synthesize top4AndScorerView;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor squareBackground];
    
    self.comparisonTable.backgroundColor = [UIColor clearColor];
    self.teamTable.backgroundColor = [UIColor clearColor];

    self.scrollView.contentSize = CGSizeMake(2*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.segmentedControl.tintColor = [UIColor segmentedControlSelected];
//    self.segmentedControl.font = [UIFont boldSystemFontOfSize:12];
    
    self.statisticView.contentSize = CGSizeMake(self.statisticView.frame.size.width, 690);
    
    NSError* error;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/competitorStats/%@/tippadeMatcher", self.ranking.competitorName] withError:&error];
    
    [BackendAdapter loadCompetitorComparison:self.ranking.competitorId :^(RemoteCallResult remoteCallResult) {
        
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
                [self scrollToNextMatch];
                [self.playerTable reloadData];
                [self.teamTable reloadData];
                
                [self setupPieChart];
        }
    }];
}

- (void) scrollToNextMatch {
    int counter = 0;
    for (MatchComparison* matchComparison in self.matchComparisons) {
        if (matchComparison.isNextMatch) {
            
            [self.comparisonTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:counter inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            return;

        }
        counter++;
    }
}

- (void) setupPieChart {
    if ([self.pointsDict count] > 0) {
        
        // points available -> create pieChart from theme
        self.pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        self.graphView.hostedGraph = self.pieChart;
        
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
        
        if ([self.pointsDict count] == 1) {
            // only one point type -> show data label centered
            piePlot.labelOffset = -100;
        }
        else {
            // multiple point types -> show data labels over the point types
            piePlot.labelOffset = -60;
        }
    }
    else {
        self.noPointsYetLabel.hidden = NO;
        CGRect frame = self.top4AndScorerView.frame;
        frame.origin.y = frame.origin.y - 210;
        self.top4AndScorerView.frame = frame;
        
        self.statisticView.contentSize = CGSizeMake(self.statisticView.contentSize.width, self.statisticView.contentSize.height - 210);
    }
}

- (void) setRanking:(Ranking *)ranking {
    _ranking = ranking;
    
    self.pointsDict = [NSMutableDictionary dictionary];
    self.indexToPointsDict = [NSMutableDictionary dictionary];
    
    int counter = 0;
    if (_ranking.perfectMatchPredictionPoints && _ranking.perfectMatchPredictionPoints.intValue > 0) {
      [self.pointsDict setValue:_ranking.perfectMatchPredictionPoints forKey:AMP_AMP];  
      [self.indexToPointsDict setObject:AMP_AMP forKey:[NSNumber numberWithInt:counter]];
      counter++;
    }
    if (_ranking.topScorerPredictionPoints && _ranking.topScorerPredictionPoints .intValue > 0) {
        [self.pointsDict setValue:_ranking.topScorerPredictionPoints forKey:SK];  
        [self.indexToPointsDict setObject:SK forKey:[NSNumber numberWithInt:counter]];
        counter++;
    }
    if (_ranking.championshipWinnerPredictionPoints && _ranking.championshipWinnerPredictionPoints.intValue > 0) {
        [self.pointsDict setValue:_ranking.championshipWinnerPredictionPoints forKey:T4];  
        [self.indexToPointsDict setObject:T4 forKey:[NSNumber numberWithInt:counter]];
        counter++;
    }
    if (_ranking.correctMatchWinnerPredictionPoints && _ranking.correctMatchWinnerPredictionPoints.intValue > 0) {
        [self.pointsDict setValue:_ranking.correctMatchWinnerPredictionPoints forKey:_1X2];  
        [self.indexToPointsDict setObject:_1X2 forKey:[NSNumber numberWithInt:counter]];
        counter++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = self.ranking.competitorName;
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
    [self setComparisonTable:nil];
    [self setGraphView:nil];
    [self setNoPointsYetLabel:nil];
    [self setStatisticView:nil];
    [self setPlayerTable:nil];
    [self setTeamTable:nil];
    [self setTop4AndScorerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)segmentedControlChange:(id)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        NSError* error;
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/competitorStats/%@/tippadeMatcher", self.ranking.competitorName] withError:&error];
        
        
    }
    else {
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        NSError* error;
        [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"app/competitorStats/%@/statistik", self.ranking.competitorName] withError:&error];
        
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == playerTable) {
        CompetitorStatisticCell* cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
        ScorerPredictionResult* scorerResult = [self.comparison.scorerPredictions objectAtIndex:indexPath.row];
        cell.name.text = scorerResult.player.name;
        cell.flag.image = scorerResult.player.team.flag;
        cell.points.text = [NSString stringWithFormat:@"%.1fp", scorerResult.score.floatValue];
        [cell setOdd:(indexPath.row % 2 != 0)];
        return cell;
    }
    
    if (tableView == teamTable) {
        CompetitorStatisticCell* cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell"];
        Top4PredictionResult* top4Result = [self.comparison.top4Predictions objectAtIndex:indexPath.row];
        cell.name.text = top4Result.team.name;
        cell.flag.image = top4Result.team.flag;
        cell.points.text = [NSString stringWithFormat:@"%.1fp", top4Result.score.floatValue];
        [cell setOdd:(indexPath.row % 2 != 0)];
        return cell;
    }
    
    ComparisonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comparisonCell"];
    cell.matchComparison = [self.matchComparisons objectAtIndex:indexPath.row];
    [cell setMyRanking:self.ranking.isMyRanking];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.playerTable) return 3;
    if (tableView == self.teamTable) return 4;
    
    return [self.matchComparisons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.comparisonTable) {
        if (self.ranking.isMyRanking) {
            return 120;     
        }
        else  {
            return 155;
        }
    }
    else {
        return 32;
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.pointsDict count];
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    NSString* pointType = [self.indexToPointsDict objectForKey:[NSNumber numberWithInt:index ]];
    
    if ([pointType isEqualToString:AMP_AMP]) {
        return [CPTFill fillWithColor:[CPTColor darkGreen]];
    }
    if ([pointType isEqualToString:SK]) {
        return [CPTFill fillWithColor:[CPTColor middleDarkGreen]];
    }
    if ([pointType isEqualToString:T4]) {
        return [CPTFill fillWithColor:[CPTColor middleLightGreen]];
    }
    else {
        return [CPTFill fillWithColor:[CPTColor lightGreen]];
    }        
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSString* pointType = [self.indexToPointsDict objectForKey:[NSNumber numberWithInt:index ]];
    NSNumber* points = [self.pointsDict objectForKey:pointType];
    return points;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {

    NSString* pointType = [self.indexToPointsDict objectForKey:[NSNumber numberWithInt:index]];
    NSNumber *points = [self.pointsDict objectForKey:pointType];

    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n(%.1fp)", pointType, points.floatValue]];
	CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    textStyle.fontSize = 15;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
	label.textStyle = textStyle;
    
    return label;
}

@end
