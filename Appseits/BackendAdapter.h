//
//  BackendAdapter.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"


typedef void(^FinishedBlock)(bool success);

@interface BackendAdapter : NSObject

+ (BOOL) validateCredentials;

+ (void) initializeModel;

+ (League*) currentLeague;
+ (void) setCurrentLeague:(League*) league:(FinishedBlock) onDone;

+ (NSArray*) tournamentRounds;
+ (NSArray*) rankings;
+ (NSArray*) leagues;


@end
