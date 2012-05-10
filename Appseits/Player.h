//
//  Player.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Player : NSObject

@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) NSNumber *playerId;
@property (nonatomic, strong) NSString *name;

+ (NSArray*) playersFromJson:(NSArray*) jsonData forTeam:(Team*) team;

@end
