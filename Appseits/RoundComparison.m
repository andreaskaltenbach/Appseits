//
//  RoundComparison.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundComparison.h"
#import "BackendAdapter.h"
#import "MatchComparison.h"

@implementation RoundComparison

@synthesize matchRound = _matchRound;
@synthesize matchComparisons = _matchComparisons;

+ (NSArray*) roundComparisonsFromJson:(NSArray*) jsonData {
    
    NSMutableArray* roundComparisons = [[NSMutableArray alloc] init];
    for (NSDictionary* roundComparisonData in jsonData) {
        
        RoundComparison* roundComparison = [RoundComparison roundComparisonFromJson:roundComparisonData];
        
        [roundComparisons addObject:roundComparison];
    }
    
    return roundComparisons;
}

+ (RoundComparison*) roundComparisonFromJson:(NSDictionary*) jsonData {
    RoundComparison* roundComparison = [[RoundComparison alloc] init];
    
    NSNumber* roundId = [jsonData valueForKey:@"roundId"];
    MatchRound* matchRound = [[BackendAdapter matchRoundMap] objectForKey:roundId];
    roundComparison.matchRound = matchRound;

    NSArray* matchComparisonData = [jsonData objectForKey:@"matches"];
    if (matchComparisonData) {
        roundComparison.matchComparisons = [MatchComparison matchComparisonsFromJson:matchComparisonData];
    }
    
    return roundComparison;
}

@end
