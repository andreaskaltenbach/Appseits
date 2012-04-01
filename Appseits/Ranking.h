//
//  Ranking.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ranking : NSObject

@property (nonatomic, strong) NSString *trend;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *gameBetPoints;
@property (nonatomic, strong) NSNumber *oneOnOnePoints;
@property (nonatomic, strong) NSNumber *topScorerPoints;
@property (nonatomic, strong) NSNumber *topFourPoints;
@end
