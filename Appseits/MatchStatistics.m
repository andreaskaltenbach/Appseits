//
//  MatchStatistics.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchStatistics.h"
#import "MatchResultDistribtion.h"

@implementation MatchStatistics

@synthesize firstTeamWinPredictionPercentage = _firstTeamWinPredictionPercentage;
@synthesize secondTeamWinPredictionPercentage = _secondTeamWinPredictionPercentage;
@synthesize drawPredictionPercentage = _drawPredictionPercentage;

@synthesize resultDistribution = _resultDistribution;

+ (MatchStatistics*) statsFromJson:(NSDictionary*) jsonData {
    MatchStatistics* stats = [[MatchStatistics alloc] init];
    
    NSDictionary* predictionDistribution = [jsonData objectForKey:@"predictionDistribution"];
    if (predictionDistribution) {
        stats.firstTeamWinPredictionPercentage = [predictionDistribution valueForKey:@"1"];
        stats.secondTeamWinPredictionPercentage = [predictionDistribution valueForKey:@"2"];
        stats.drawPredictionPercentage = [predictionDistribution valueForKey:@"x"];
    }
    
    NSDictionary* predictedOutcomeDistribution = [jsonData objectForKey:@"predictedOutcomeDistribution"];
    if (predictedOutcomeDistribution) {
        NSMutableArray* resultDistribution = [NSMutableArray array];
        
        [predictionDistribution enumerateKeysAndObjectsUsingBlock:^(NSString* result, NSNumber* percentage, BOOL *stop) {
            [resultDistribution addObject:[MatchResultDistribtion resultDistribution:result :percentage]];
        }];
        
    }
    return stats;
}

@end
