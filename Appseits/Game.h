//
//  Match.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Game : NSObject

@property (nonatomic, strong) NSString *firstTeamName;
@property (nonatomic, strong) NSString *secondTeamName;
@property (nonatomic, strong) NSDate *kickOff;
@property (nonatomic, strong) NSNumber *firstTeamGoals;
@property (nonatomic, strong) NSNumber *secondTeamGoals;
@property (nonatomic, strong) NSNumber *firstTeamPrediction;
@property (nonatomic, strong) NSNumber *secondTeamPrediction;
@property (nonatomic, strong) NSNumber *points;

+ (NSArray*) gamesFromJson: (NSArray*) jsonData;

@end
