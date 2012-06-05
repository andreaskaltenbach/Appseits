//
//  Top4PredictionResult.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Top4PredictionResult : NSObject

@property (nonatomic, strong) Team* team;
@property (nonatomic, strong) NSNumber* score;

+ (NSArray*) top4ResultsFromJson:(NSArray*) jsonData;

@end
