//
//  TournamentRound.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchRound.h"
#import "Match.h"
#import "NSDate+DateConversion.h"

@implementation MatchRound

@synthesize matches = _matches;

- (float) points {
    float points = 0.0f;
    for(Match *game in self.matches) {
        points += game.points.floatValue;
    }
    return points;
}

+ (MatchRound*) tournamentRoundFromJson:(NSDictionary*) jsonData {
    MatchRound *round = [[MatchRound alloc] init];
    round.roundName = [jsonData objectForKey:@"name"];
    round.matches = [Match matchFromJson: [jsonData objectForKey:@"matches"]];
    round.startDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"startDate"]];
    round.lockDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"lockedDate"]];
    
    return round;
}

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds {
    NSMutableArray *rounds = [NSMutableArray array];
    
    for (NSDictionary *roundData in jsonRounds) {
        [rounds addObject:[MatchRound tournamentRoundFromJson:roundData]];
    }
    
    return rounds;
}

- (float) progress {
    float matchPercentage = 1/[self.matches count];
    NSLog(@"Match percentage: %f", matchPercentage);
    
    float progress = 0;
    for (Match* match in self.matches) {

        if (!match.finished) {
            return progress;
        }
        
        progress+= matchPercentage;
    }

    NSLog(@"Final percentage: %f", matchPercentage);
    return progress;
}

- (BOOL) allPredictionsDone {
    for (Match* match in self.matches) {
        if (!match.hasPrediction) {
            return NO;
        }
    }
    return YES;
}


@end
