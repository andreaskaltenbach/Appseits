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

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *gameBetPoints;
@property (nonatomic, strong) NSNumber *oneOnOnePoints;
@property (nonatomic, strong) NSNumber *topScorerPoints;
@property (nonatomic, strong) NSNumber *topFourPoints;
@property Trend trend;

+ (NSArray*) rankingsFromJson: (NSArray*) jsonRankings;
@end
