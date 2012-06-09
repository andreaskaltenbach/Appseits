//
//  MatchStatistics.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchStatistics : NSObject

@property (nonatomic, strong) NSNumber* firstTeamWinPredictionPercentage;
@property (nonatomic, strong) NSNumber* secondTeamWinPredictionPercentage;
@property (nonatomic, strong) NSNumber* drawPredictionPercentage;

@property (nonatomic, strong) NSArray* resultDistribution;

+ (MatchStatistics*) statsFromJson:(NSDictionary*) jsonData;

@end
