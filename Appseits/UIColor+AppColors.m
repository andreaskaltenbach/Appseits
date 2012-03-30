//
//  UIColor+AppColors.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor*) blackBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"blck.png"]];
}

+ (UIColor*) squareBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"square.png"]];
}

+ (NSArray *) gameCellGradient {
    return [NSArray arrayWithObjects: 
            (id) [[UIColor colorWithRed:210.0/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1] CGColor],
            (id)  [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor],
            nil];
}

+ (NSArray *) menuGrayGradient {
    return [NSArray arrayWithObjects: 
            (id) [[UIColor colorWithRed:202.0/255.0f green:202.0f/255.0f blue:202.0f/255.0f alpha:1] CGColor],
            (id)  [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor],
            nil];
}

+ (NSArray *) menuGreenGradient {
    return [NSArray arrayWithObjects: 
            (id) [[UIColor colorWithRed:50.0/255.0f green:98.0/255.0f blue:10.0/255.0f alpha:1] CGColor],
            (id) [[UIColor colorWithRed:116.0/255.0f green:173.0/255.0f blue:53.0/255.0f alpha:1] CGColor],
            nil];
}

+ (UIColor*) highlightedGreen {
    return [UIColor colorWithRed:51.0/255.0f green:99.0f/255.0f blue:11.0f/255.0f alpha:1];
}

+ (UIColor*) progressWaves {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"progress.png"]];
}

+ (UIColor*) separatorVertical {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"separator.png"]];
}

+ (UIColor*) orangeSeparator {
    return [UIColor colorWithRed:198.0/255.0f green:79.0f/255.0f blue:51.0f/255.0f alpha:1];
}

@end
