//
//  Ranking.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    UP,
    UNCHANGED,
    DOWN
} Trend;

@interface Ranking : NSObject

@property (nonatomic, strong) NSString *competitorName;
@property (nonatomic, strong) NSString *competitorId;
@property (nonatomic, strong) NSNumber *rank;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *correctMatchWinnerPredictionPoints;
@property (nonatomic, strong) NSNumber *topScorerPredictionPoints;
@property (nonatomic, strong) NSNumber *perfectMatchPredictionPoints;
@property (nonatomic, strong) NSNumber *championshipWinnerPredictionPoints;
@property Trend trend;

+ (NSArray*) rankingsFromJson: (NSArray*) jsonRankings;

- (BOOL) isMyRanking;
@end
