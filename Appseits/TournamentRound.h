//
//  TournamentRound.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TournamentRound : NSObject

@property (nonatomic, strong) NSString *roundName;
@property (nonatomic, strong) NSArray* games;
@property BOOL locked;

- (int) points;

+ (NSArray*) tournamentRoundsFromJson: (NSArray*) jsonRounds;

@end
