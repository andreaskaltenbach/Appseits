//
//  Match.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Match : NSObject

@property (nonatomic, strong) NSString *firstTeamName;
@property (nonatomic, strong) NSString *secondTeamName;
@property (nonatomic, strong) NSDate *kickOff;
@property (nonatomic, strong) NSNumber *firstTeamGoals;
@property (nonatomic, strong) NSNumber *secondTeamGoals;
@property (nonatomic, strong) NSNumber *firstTeamPrediction;
@property (nonatomic, strong) NSNumber *secondTeamPrediction;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSNumber *matchId;
@property BOOL played;
@property BOOL unknownOpponents;

+ (NSArray*) matchFromJson: (NSArray*) jsonData;

- (BOOL) finished;

@end
