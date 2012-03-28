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

+ (UIColor*) highlightedGreen {
    //TODO - adjust color
    return [UIColor greenColor];
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
