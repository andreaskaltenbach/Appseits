    //
//  CPTColor+AppColors.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CPTColor+AppColors.h"
#import "CorePlot-CocoaTouch.h"
#import <QuartzCore/QuartzCore.h>

@implementation CPTColor (AppColors)

+(CPTColor *) darkGreen {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float rgb[4] = {49.0/255.0, 110.0/255.0, 9.0/255.0, 1.0};
    CGColorRef color = CGColorCreate(colorSpace, rgb);
    return [CPTColor colorWithCGColor:color];
}

+(CPTColor *) middleGreen {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float rgb[4] = {68.0/255.0, 130.0/255.0, 2.0/255.0, 1.0};
    CGColorRef color = CGColorCreate(colorSpace, rgb);
    return [CPTColor colorWithCGColor:color];
}

+(CPTColor *) lightGreen {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float rgb[4] = {82.0/255.0, 150.0/255.0, 10.0/255.0, 1.0};
    CGColorRef color = CGColorCreate(colorSpace, rgb);
    return [CPTColor colorWithCGColor:color];
}

@end
