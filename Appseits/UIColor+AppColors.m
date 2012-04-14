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
            [UIColor colorWithRed:210.0/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1],
            [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
            nil];
}

+ (NSArray *) menuGrayGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:202.0/255.0f green:202.0f/255.0f blue:202.0f/255.0f alpha:1],
            [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
            nil];
}

+ (NSArray *) greenGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:50.0/255.0f green:98.0/255.0f blue:10.0/255.0f alpha:1],
            [UIColor colorWithRed:116.0/255.0f green:173.0/255.0f blue:53.0/255.0f alpha:1],
            nil];
}

+ (NSArray *) darkGrayGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:40.0/255.0f green:40.0/255.0f blue:40.0/255.0f alpha:1],
            [UIColor colorWithRed:111.0/255.0f green:111.0/255.0f blue:111.0/255.0f alpha:1],
            nil];
}

+ (NSArray *) grayGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:97.0/255.0f green:97.0/255.0f blue:97.0/255.0f alpha:1],
            [UIColor colorWithRed:127.0/255.0f green:127.0/255.0f blue:127.0/255.0f alpha:1],
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

+ (UIColor *) darkGreen {
    return [UIColor colorWithRed:49.0/255.0f green:110.0f/255.0f blue:9.0f/255.0f alpha:1];
}

+ (UIColor *) rankingSelected {
    return [UIColor colorWithRed:116.0/255.0f green:173.0f/255.0f blue:54.0f/255.0f alpha:1];
}

+ (UIColor *) rankingOdd {
    return [UIColor colorWithRed:188.0/255.0f green:199.0f/255.0f blue:200.0f/255.0f alpha:0.3];
}

+ (UIColor *) rankingEven {
    return [UIColor clearColor];
}


@end
