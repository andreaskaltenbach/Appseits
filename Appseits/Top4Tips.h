//
//  Top4Tips.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Top4Tips : NSObject

@property (nonatomic, strong) NSArray* allTeams;

@property (nonatomic, strong) NSString* firstTeam;
@property (nonatomic, strong) NSString* secondTeam;
@property (nonatomic, strong) NSString* thirdTeam;
@property (nonatomic, strong) NSString* fourthTeam;

+ (Top4Tips*) fromJson: (NSDictionary*) jsonData;

@end
