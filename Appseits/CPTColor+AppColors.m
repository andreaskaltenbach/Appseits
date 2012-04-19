    //
//  CPTColor+AppColors.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CPTColor+AppColors.h"
#import "CorePlot-CocoaTouch.h"

@implementation CPTColor (AppColors)

+(CPTColor *) darkGreen {
    CGColorRef color = [[UIColor colorWithRed:49.0/255.0 green:110.0/255.0 blue:9.0/255.0 alpha:1] CGColor];
    return [CPTColor colorWithCGColor:color];
}

+(CPTColor *) middleGreen {
    CGColorRef color = [[UIColor colorWithRed:68.0/255.0 green:130.0/255.0 blue:2.0/255.0 alpha:1] CGColor];
    return [CPTColor colorWithCGColor:color];
}

+(CPTColor *) lightGreen {
    CGColorRef color = [[UIColor colorWithRed:82.0/255.0 green:150.0/255.0 blue:10.0/255.0 alpha:1] CGColor];
    return [CPTColor colorWithCGColor:color];
}

@end
