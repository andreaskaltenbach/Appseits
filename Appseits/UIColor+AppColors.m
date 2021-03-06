//
//  UIColor+AppColors.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor*) headerBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"headerPattern.png"]];
}

+ (UIColor*) menuBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menuBackground"]];
}

+ (UIColor*) menuSelectedBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menuSelectedBackground.png"]];
}

+ (UIColor*) blackBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"blck.png"]];
}

+ (NSArray *) todaySectionBackground {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:164.0/255.0f green:52.0f/255.0f blue:31.0f/255.0f alpha:1],
            [UIColor colorWithRed:203.0/255.0f green:91.0f/255.0f blue:67.0f/255.0f alpha:1],
            [UIColor colorWithRed:203.0/255.0f green:91.0f/255.0f blue:67.0f/255.0f alpha:1],
            [UIColor colorWithRed:203.0/255.0f green:91.0f/255.0f blue:67.0f/255.0f alpha:1],
            [UIColor colorWithRed:164.0/255.0f green:52.0f/255.0f blue:31.0f/255.0f alpha:1],
            nil];  
}

+ (UIColor*) squareBackground {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"square.png"]];
}

+ (NSArray *) selectedUnfinishedSection {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:231.0/255.0f green:129.0f/255.0f blue:105.0f/255.0f alpha:1],
            [UIColor colorWithRed:192.0/255.0f green:59.0f/255.0f blue:27.0f/255.0f alpha:1],
            nil];  
}

+ (NSArray *) selectedSection {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:116.0/255.0f green:173.0f/255.0f blue:53.0f/255.0f alpha:1],
            [UIColor colorWithRed:50.0/255.0f green:98.0f/255.0f blue:10.0f/255.0f alpha:1],
            nil];  
}

+ (NSArray *) gameCellGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:210.0/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1],
            [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
            nil];
}

+ (NSArray *) grayBackgroundGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:210.0/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1],
            [UIColor whiteColor],
            nil];
}

+ (NSArray *) lastUpdatedGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:247.0/255.0f green:246.0/255.0f blue:194.0/255.0f alpha:1],
            [UIColor colorWithRed:226.0/255.0f green:215.0/255.0f blue:126.0/255.0f alpha:1],
            nil];
}

+ (UIColor*) lastUpdatedTextColor {
    return [UIColor colorWithRed:84.0/255.0f green:77.0/255.0f blue:21.0/255.0f alpha:1];
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
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"timelineProgress"]];
}

+ (UIColor*) orangeLine {
    return [UIColor colorWithRed:196.0/255.0f green:76.0f/255.0f blue:55.0f/255.0f alpha:1];
}

+ (UIColor*) separatorVertical {
    return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"separator.png"]];
}

+ (UIColor *) darkGreen {
    return [UIColor colorWithRed:49.0/255.0f green:110.0f/255.0f blue:9.0f/255.0f alpha:1];
}

+ (UIColor *) credentialsBackground {
    return [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
}

+ (UIColor *) credentialsSeparator {
    return [UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1];
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

+ (UIColor *) transparentWhite {
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

+ (UIColor *) settingsTextColor {
    return [UIColor colorWithRed:166.0/255.0f green:166.0/255.0f blue:166.0/255.0f alpha:1];
}

+ (NSArray *) timelineGradient {
    return [NSArray arrayWithObjects: 
            [UIColor whiteColor],
            [UIColor colorWithRed:202.0/255.0f green:202.0/255.0f blue:202.0/255.0f alpha:1],
            nil];
}

+ (NSArray *) errorGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:247.0/255.0f green:218.0/255.0f blue:194.0/255.0f alpha:1],
            [UIColor colorWithRed:227.0/255.0f green:196.0/255.0f blue:179.0/255.0f alpha:1],
            nil];
}

+ (UIColor *) errorBorder {
    return [UIColor colorWithRed:188.0/255.0f green:157.0/255.0f blue:136.0/255.0f alpha:1];
}

+ (NSArray *) confirmationGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:215.0/255.0f green:249.0/255.0f blue:180.0/255.0f alpha:1],
            [UIColor colorWithRed:196.0/255.0f green:225.0/255.0f blue:166.0/255.0f alpha:1],
            nil];
}

+ (UIColor *) confirmationBorder {
    return [UIColor colorWithRed:128.0/255.0f green:182.0/255.0f blue:79.0/255.0f alpha:1];
}

+ (NSArray *) doubledLightBlueGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0.15],
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0],
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0.15],
            nil];    
}

+ (NSArray *) lightBlueGradient {
    return [NSArray arrayWithObjects: 
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0.1],
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0],
            [UIColor colorWithRed:14.0/255.0f green:162.0/255.0f blue:189.0/255.0f alpha:0],
            nil];    
}


@end
