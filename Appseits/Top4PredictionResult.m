//
//  Top4PredictionResult.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4PredictionResult.h"
#import "Team.h"
#import "BackendAdapter.h"

@implementation Top4PredictionResult

@synthesize team = _team;
@synthesize score = _score;

+ (NSArray*) top4ResultsFromJson:(NSArray*) jsonData {
    NSMutableArray* top4Results = [NSMutableArray array];
    for (NSDictionary* top4Result in jsonData) {
        [top4Results addObject:[Top4PredictionResult top4ResultFromJson:top4Result]];
    }
    
    return top4Results;
}

+ (Top4PredictionResult*) top4ResultFromJson:(NSDictionary*) jsonData {
    Top4PredictionResult* top4Result = [[Top4PredictionResult alloc] init];
    
    NSNumber* teamId = [jsonData objectForKey:@"teamId"];
    top4Result.team = [[BackendAdapter teams] objectForKey:teamId];
    
    top4Result.score = [jsonData valueForKey:@"score"];
    return top4Result;
}

@end
