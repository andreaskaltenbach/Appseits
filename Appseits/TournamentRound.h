//
//  TournamentRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CLOSED,
    OPEN,
    FUTURE
} RoundState;

@interface TournamentRound : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *lockDate;
@property (nonatomic, strong) NSString *roundName;

- (RoundState) roundState;

- (int) points;

@end
