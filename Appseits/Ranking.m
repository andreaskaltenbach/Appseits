//
//  Ranking.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ranking.h"

@implementation Ranking

@synthesize trend = _trend;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize totalPoints = _totalPoints;
@synthesize gameBetPoints = _gameBetPoints;
@synthesize oneOnOnePoints = _oneOnOnePoints;
@synthesize topScorerPoints = _topScorerPoints;
@synthesize topFourPoints = _topFourPoints;
@synthesize rank = _rank;

+ (Ranking*) rankingFromJson:(NSDictionary*) jsonData {
    Ranking *ranking = [[Ranking alloc] init];
    ranking.userId = [jsonData objectForKey:@"userId"];
    ranking.userName = [jsonData objectForKey:@"userName"];
    NSNumber *points = [jsonData objectForKey:@"points"];
    if (points) ranking.totalPoints = points;
    
    
    NSString *trend = [jsonData objectForKey:@"trend"];
    if (trend) {
        if ([trend isEqualToString:@"up"]) {
            ranking.trend = UP;
        }
        else if ([trend isEqualToString:@"down"]) {
            ranking.trend = DOWN;
        }
        else {
            ranking.trend = UNCHANGED;
        }                 
    }
    
    if (points) ranking.totalPoints = points;
    return ranking;
}

+ (NSArray*) rankingsFromJson: (NSArray*) jsonRankings {

    int counter = 1;
    
    NSMutableArray *rankings = [NSMutableArray array];
    for (NSDictionary *rankingData in jsonRankings) {
        Ranking *ranking = [Ranking rankingFromJson:rankingData];
        ranking.rank = [NSNumber numberWithInt:counter++];
        [rankings addObject:ranking];
    }
    
    return rankings;
}

@end
