//
//  NSDate+DateConversion.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+DateConversion.h"

@implementation NSDate (DateConversion)

+ (NSDate*) fromJsonTimestamp:(id) timestamp {
return [NSDate dateWithTimeIntervalSince1970:([timestamp doubleValue])];
}
@end
