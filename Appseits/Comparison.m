//
//  Comparison.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Comparison.h"
#import "RoundComparison.h"
#import "Top4PredictionResult.h"
#import "ScorerPredictionResult.h"
#import "MatchComparison.h"

@implementation Comparison

@synthesize myInitials = _myInitials;
@synthesize competitorInitials = _competitorInitials;
@synthesize competitorName = _competitorName;
@synthesize roundComparisons = _roundComparisons;

@synthesize scorerPredictions = _scorerPredictions;
@synthesize top4Predictions = _top4Predictions;

+ (Comparison*) comparisonFromJson:(NSDictionary*) jsonData {
   
    Comparison* comparison = [[Comparison alloc] init];
    
    NSDictionary* myInfo = [jsonData objectForKey:@"compareWith"];
    if (myInfo) {
        comparison.myInitials = [myInfo valueForKey:@"initials"];
    }
    
    NSDictionary* competitorInfo = [jsonData objectForKey:@"competitor"];
    if (competitorInfo) {
        comparison.competitorInitials = [competitorInfo valueForKey:@"initials"];
        comparison.competitorName = [competitorInfo valueForKey:@"fullName"];
    }
    
    NSArray* rounds = [jsonData objectForKey:@"rounds"];
    if (rounds) {
        
        MatchComparison* nextMatch;
        NSDate* now = [NSDate date];
        
        comparison.roundComparisons = [RoundComparison roundComparisonsFromJson:rounds];
        for (RoundComparison* roundComparison in comparison.roundComparisons) {
            roundComparison.comparison = comparison;
            
            // scan for next match
            for (MatchComparison* matchComparison in roundComparison.matchComparisons) {
                if (!nextMatch) {
                    // add 90 mins match time + 15 mins half time + 5 mins extra time!
                    NSDate* finalWhistle = [matchComparison.match.kickOff dateByAddingTimeInterval:60*110];
                    if ([now compare:finalWhistle] == NSOrderedAscending) {
                        nextMatch = matchComparison;
                    }
                }
            }
        }
        
        // set next match
        nextMatch.isNextMatch = YES;
    }
    
    NSArray* winners = [competitorInfo objectForKey:@"winners"];
    if (winners) {
        comparison.top4Predictions = [Top4PredictionResult top4ResultsFromJson:winners];
    }
    
    NSArray* scorers = [competitorInfo objectForKey:@"topScorers"];
    if (scorers) {
        comparison.scorerPredictions = [ScorerPredictionResult scorerResultsFromJson:scorers];
    }
    
    return comparison;
}

@end
