//
//  ScorerResult.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface ScorerPredictionResult : NSObject

@property (nonatomic, strong) Player* player;
@property (nonatomic, strong) NSNumber* score;

+ (NSArray*) scorerResultsFromJson:(NSArray*) jsonData;


@end
