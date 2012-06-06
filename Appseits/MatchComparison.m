//
//  MatchComparison.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchComparison.h"
#import "BackendAdapter.h"
#import "Match.h"


@implementation MatchComparison

@synthesize match = _match;
@synthesize myPredictionFirstTeam = _myPredictionFirstTeam;
@synthesize myPredictionSecondTeam = _myPredictionSecondTeam;
@synthesize myPredictionScore = _myPredictionScore;
@synthesize competitorPredictionFirstTeam = _competitorPredictionFirstTeam;
@synthesize competitorScore = _competitorScore;
@synthesize competitorPredictionSecondTeam = _competitorPredictionSecondTeam;
@synthesize roundComparison = _roundComparison;
@synthesize isNextMatch = _isNextMatch;

+ (NSArray*) matchComparisonsFromJson:(NSArray*) jsonData {
    
    NSMutableArray* matchComparisons = [NSMutableArray array];
    
    for (NSDictionary* matchComparison in jsonData) {
        [matchComparisons addObject:[MatchComparison matchComparisonFromJson:matchComparison]];
    }
    
    return matchComparisons;
}

+ (MatchComparison*) matchComparisonFromJson:(NSDictionary*) jsonData {
    
    MatchComparison* matchComparison = [[MatchComparison alloc] init];
    
    NSNumber* matchId = [jsonData valueForKey:@"matchId"];
    Match* match = [[BackendAdapter matchMap] objectForKey:matchId];
    matchComparison.match = match;
    
    NSDictionary* myPrediction = [jsonData objectForKey:@"comparePrediction"];
    NSDictionary* myOutcome = [myPrediction objectForKey:@"outcome"];
    matchComparison.myPredictionFirstTeam = [myOutcome valueForKey:@"homeTeamGoals"];
    matchComparison.myPredictionSecondTeam = [myOutcome valueForKey:@"awayTeamGoals"];
    matchComparison.myPredictionScore = [myPrediction valueForKey:@"score"];
    
    NSDictionary* competitorPrediction = [jsonData objectForKey:@"prediction"];
    NSDictionary* competitorOutcome = [competitorPrediction objectForKey:@"outcome"];
    matchComparison.competitorPredictionFirstTeam = [competitorOutcome valueForKey:@"homeTeamGoals"];
    matchComparison.competitorPredictionSecondTeam = [competitorOutcome valueForKey:@"awayTeamGoals"];
    matchComparison.competitorScore = [competitorPrediction valueForKey:@"score"];
    
    return matchComparison;
}

@end
