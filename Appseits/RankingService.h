//
//  RankingService.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RankingSuccessBlock)(NSArray *rankings);
typedef void(^RankingFailedBlock)(NSString * errorMessage);

@interface RankingService : NSObject

+ (void) getRankingsForLeague:(NSNumber*) leagueId: (RankingSuccessBlock) onSuccess: (RankingFailedBlock) onError;

@end
