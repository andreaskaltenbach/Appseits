//
//  League.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LeagueSuccessBlock)(NSArray *leagues);
typedef void(^LeagueFailedBlock)(NSString * errorMessage);

@interface League : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;

+ (void) getAllLeagues:(LeagueSuccessBlock) onSuccess: (LeagueFailedBlock) onError;

+ (League*) league:(NSNumber*) id: (NSString*) name;

+ (League*) selectedLeague;
+ (void) setSelectedLeague:(League*) league;

@end