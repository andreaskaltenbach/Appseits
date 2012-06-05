//
//  RoundComparison.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchRound.h"

@interface RoundComparison : NSObject

@property (nonatomic, strong) MatchRound* matchRound;
@property (nonatomic, strong) NSArray* matchComparisons;

+ (NSArray*) roundComparisonsFromJson:(NSArray*) jsonData;


@end
