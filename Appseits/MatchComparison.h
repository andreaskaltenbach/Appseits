//
//  MatchComparison.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Match.h"
#import "RoundComparison.h"

@interface MatchComparison : NSObject

@property (nonatomic, strong) Match* match;

@property (nonatomic, strong) NSNumber* myPredictionFirstTeam;
@property (nonatomic, strong) NSNumber* myPredictionSecondTeam;
@property (nonatomic, strong) NSNumber* myPredictionScore;

@property (nonatomic, strong) NSNumber* competitorPredictionFirstTeam;
@property (nonatomic, strong) NSNumber* competitorPredictionSecondTeam;
@property (nonatomic, strong) NSNumber* competitorScore;

@property (nonatomic, strong) RoundComparison* roundComparison;

@property BOOL isNextMatch;

+ (NSArray*) matchComparisonsFromJson:(NSArray*) jsonData;

@end
