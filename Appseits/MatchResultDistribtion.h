//
//  MatchResultDistribtion.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchResultDistribtion : NSObject

@property (nonatomic, strong) NSString* result;
@property (nonatomic, strong) NSNumber* percentage;

+ (MatchResultDistribtion*) resultDistribution:(NSString*) result: (NSNumber*) percentage;

@end
