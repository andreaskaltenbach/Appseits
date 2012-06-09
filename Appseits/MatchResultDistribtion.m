//
//  MatchResultDistribtion.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchResultDistribtion.h"

@implementation MatchResultDistribtion

@synthesize percentage = _percentage;
@synthesize result = _result;

+ (MatchResultDistribtion*) resultDistribution:(NSString*) result: (NSNumber*) percentage {
    MatchResultDistribtion* distribution = [[MatchResultDistribtion alloc] init];
    distribution.result = result;
    distribution.percentage = percentage;
    return  distribution;
}

@end
