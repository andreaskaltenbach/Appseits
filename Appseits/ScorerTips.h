//
//  ScorerTips.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface ScorerTips : NSObject

@property (nonatomic, strong) Player *firstPlayer;
@property (nonatomic, strong) NSNumber* firstPlayerPoints;

@property (nonatomic, strong) Player *secondPlayer;
@property (nonatomic, strong) NSNumber* secondPlayerPoints;

@property (nonatomic, strong) Player *thirdPlayer;
@property (nonatomic, strong) NSNumber* thirdPlayerPoints;

+ (ScorerTips*) fromJson: (NSArray*) jsonData;

@end
