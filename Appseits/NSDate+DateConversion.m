//
//  NSDate+DateConversion.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+DateConversion.h"

#define REGEX @"[0-9]+"

@implementation NSDate (DateConversion)

+ (NSDate*) fromJsonTimestamp:(id) timestamp {
    if (!timestamp) return nil;
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:REGEX
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSRange range   = [regex rangeOfFirstMatchInString:timestamp
                                               options:0 
                                                 range:NSMakeRange(0, [timestamp length])];
    NSString *result = [timestamp substringWithRange:range];
    return [NSDate dateWithTimeIntervalSince1970:([result doubleValue]/1000)];
}
@end
