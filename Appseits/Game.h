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
@property int firstTeamGoals;
@property int secondTeamGoals;
@property int firstTeamPrediction;
@property int secondTeamPrediction;
@property int points;


+ (NSArray*) gamesFromJson: (NSArray*) jsonData;

@end
