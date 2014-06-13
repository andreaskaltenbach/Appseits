//
//  ScorerResult.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerPredictionResult.h"
#import "Player.h"
#import "BackendAdapter.h"

@implementation ScorerPredictionResult


@synthesize player = _player;
@synthesize score = _score;

+ (NSArray*) scorerResultsFromJson:(NSArray*) jsonData {
    NSMutableArray* scorerResults = [NSMutableArray array];
    for (NSDictionary* scorerResult in jsonData) {
        [scorerResults addObject:[ScorerPredictionResult scorerResultFromJson:scorerResult]];
    }
    
    return scorerResults;
}
+ (ScorerPredictionResult*) scorerResultFromJson:(NSDictionary*) jsonData {
    ScorerPredictionResult* scorerResult = [[ScorerPredictionResult alloc] init];
    
    NSNumber* playerId = [jsonData objectForKey:@"playerId"];
    scorerResult.player = [[BackendAdapter players] objectForKey:playerId];
    
    scorerResult.score = [jsonData valueForKey:@"score"];
    return scorerResult;
}

@end
