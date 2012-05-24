//
//  Top4Tips.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Top4Tips : NSObject

@property (nonatomic, strong) Team* firstTeam;
@property (nonatomic, strong) NSNumber* firstTeamPoints;

@property (nonatomic, strong) Team* secondTeam;
@property (nonatomic, strong) NSNumber* secondTeamPoints;

@property (nonatomic, strong) Team* thirdTeam;
@property (nonatomic, strong) NSNumber* thirdTeamPoints;

@property (nonatomic, strong) Team* fourthTeam;
@property (nonatomic, strong) NSNumber* fourthTeamPoints;


+ (Top4Tips*) fromJson: (NSDictionary*) jsonData;

@end
