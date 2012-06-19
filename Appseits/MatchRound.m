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
#import "BackendAdapter.h"

@implementation MatchRound

@synthesize matches = _matches;
@synthesize roundId = _roundId;

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
    for (Match* match in round.matches) {
        match.matchRound = round;
    }
    round.startDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"startDate"]];
    round.lockDate = [NSDate fromJsonTimestamp:[jsonData objectForKey:@"lockedDate"]];
    
    
    round.roundId = [jsonData valueForKey:@"roundId"];
    
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
    float matchPercentage = 1.0f/ (float) [self.matches count];
    float progress = 0;
    for (Match* match in self.matches) {

        if (!match.finished) {
            return progress;
        }
        
        progress+= matchPercentage;
    }
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

+ (Match*) previousPredictableMatch:(Match*) match {
    MatchRound* matchRound = match.matchRound;
    int matchIndex = [matchRound.matches indexOfObject:match];
    if (matchIndex != 0) {
        // there is a match before the given one in the same round
        return [matchRound.matches objectAtIndex:matchIndex - 1];
    }
    else {
        // last match of the subsequent match round
        NSArray* matchRounds = [BackendAdapter matchRounds];
        int roundIndex = [matchRounds indexOfObject:matchRound];
        
        if (roundIndex != 0) {
            MatchRound* previousMatchRound = [matchRounds objectAtIndex:roundIndex - 1];
            if (previousMatchRound.readyToBet && previousMatchRound.notPassed) {
                return [previousMatchRound.matches lastObject];
            }
        }
    }
    
    // no previous match found
    return nil;
}

+ (Match*) nextPredictableMatch:(Match*) match {
    MatchRound* matchRound = match.matchRound;
    int matchIndex = [matchRound.matches indexOfObject:match];
    if (matchIndex < [matchRound.matches count] -1) {
        // there is a match after the given one in the same round
        return [matchRound.matches objectAtIndex:matchIndex + 1];
    }
    else {
        // first match of the subsequent match round
        NSArray* matchRounds = [BackendAdapter matchRounds];
        int roundIndex = [matchRounds indexOfObject:matchRound];
        
        if (roundIndex < [matchRounds count] -1) {
            MatchRound *nextRound = [matchRounds objectAtIndex:roundIndex + 1];
            if (nextRound.readyToBet) {
                return [nextRound.matches objectAtIndex:0];
            }
                
            
        }
        
    }
    
    // no follow up match found
    return nil;
}

@end
