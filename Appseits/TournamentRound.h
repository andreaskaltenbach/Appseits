//
//  TournamentRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CLOSED,
    OPEN,
    FUTURE
} RoundState;

@interface TournamentRound : NSObject

@property (nonatomic, strong) NSString *roundName;
@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *lockDate;

- (int) points;
- (BOOL) locked;

- (BOOL) isActive;

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds;

- (RoundState) roundState;

@end
