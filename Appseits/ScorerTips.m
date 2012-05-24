//
//  ScorerTips.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerTips.h"
#import "BackendAdapter.h"

@implementation ScorerTips

@synthesize firstPlayer = _firstPlayer;
@synthesize firstPlayerPoints = _firstPlayerPoints;

@synthesize secondPlayer = _secondPlayer;
@synthesize secondPlayerPoints = _secondPlayerPoints;

@synthesize thirdPlayer = _thirdPlayer;
@synthesize thirdPlayerPoints = _thirdPlayerPoints;

+ (ScorerTips*) fromJson: (NSArray*) jsonData {
    
    NSDictionary* allPlayers = [BackendAdapter players];
    
    ScorerTips *tips = [[ScorerTips alloc] init];
    NSLog(@"JSON: %@", jsonData);
    
    for (NSDictionary *prediction in jsonData) {
        NSNumber *place = [prediction valueForKey:@"place"];
        NSNumber *playerId = [prediction valueForKey:@"playerId"];
        NSNumber *score = [prediction valueForKey:@"score"];
        
        if (place.intValue != 0 && playerId != 0) {
            
            Player *player = [allPlayers objectForKey:playerId];
            
            if (place.intValue == 1) {
                tips.firstPlayer = player;
                tips.firstPlayerPoints = score;
            }
            if (place.intValue == 2) {
                tips.secondPlayer = player;
                tips.secondPlayerPoints = score;
            }
            if (place.intValue == 3) {
                tips.thirdPlayer = player;
                tips.thirdPlayerPoints = score;
            }
        }
    }
    
    return tips;
}

@end
