//
//  Ranking.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ranking.h"
#import "BackendAdapter.h"

@implementation Ranking

@synthesize trend = _trend;
@synthesize competitorId = _competitorId;
@synthesize competitorName = _competitorName;
@synthesize totalPoints = _totalPoints;
@synthesize correctMatchWinnerPredictionPoints = _correctMatchWinnerPredictionPoints;
@synthesize topScorerPredictionPoints = _topScorerPredictionPoints;
@synthesize perfectMatchPredictionPoints = _perfectMatchPredictionPoints;
@synthesize championshipWinnerPredictionPoints = _championshipWinnerPredictionPoints;
@synthesize rank = _rank;

+ (Ranking*) rankingFromJson:(NSDictionary*) jsonData {
    Ranking *ranking = [[Ranking alloc] init];
    ranking.rank = [jsonData objectForKey:@"rankingPosition"];
    ranking.competitorId = [jsonData objectForKey:@"competitorUserId"];
    ranking.competitorName = [jsonData objectForKey:@"competitorName"];
    NSArray *points = [jsonData objectForKey:@"points"];
    
    if (points) {
        ranking.totalPoints = [points valueForKey:@"totalPoints"];
        ranking.perfectMatchPredictionPoints = [points valueForKey:@"perfectMatchPredictionPoints"];
        ranking.correctMatchWinnerPredictionPoints = [points valueForKey:@"correctMatchWinnerPredictionPoints"];
        ranking.topScorerPredictionPoints = [points valueForKey:@"topScorerPredictionPoints"];
        ranking.championshipWinnerPredictionPoints = [points valueForKey:@"championshipWinnerPredictionPoints"];
    }
    
    
    NSNumber *trend = [jsonData objectForKey:@"competitorTrend"];
    if (trend) {
        
        switch (trend.intValue) {
            case 1:
                ranking.trend = UP;
                break;
            case -1:
                ranking.trend = DOWN;
                break;
            default:
                ranking.trend = UNCHANGED;
                break;
        }   
    }
    
    return ranking;
}

- (BOOL) isMyRanking {
    return [[BackendAdapter userId] isEqualToString:self.competitorId];
}

+ (NSArray*) rankingsFromJson: (NSArray*) jsonRankings {

    NSMutableArray *rankings = [NSMutableArray array];
    for (NSDictionary *rankingData in jsonRankings) {
        Ranking *ranking = [Ranking rankingFromJson:rankingData];
        [rankings addObject:ranking];
    }
    
    return rankings;
}

@end
