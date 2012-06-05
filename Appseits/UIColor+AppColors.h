//
//  UIColor+AppColors.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)

+ (NSArray *) lastUpdatedGradient;
+ (UIColor*) lastUpdatedTextColor;

+ (UIColor*) headerBackground;

+ (UIColor*) menuBackground;
+ (UIColor*) menuSelectedBackground;

+ (NSArray *) grayBackgroundGradient;

+ (UIColor*) blackBackground;

+ (NSArray *) todaySectionBackground;

+ (UIColor*) squareBackground;

+ (UIColor*) highlightedGreen;

+ (NSArray *) gameCellGradient;

+ (NSArray *) selectedUnfinishedSection;
+ (NSArray *) selectedSection;

+ (UIColor*) progressWaves;

+ (UIColor*) orangeLine;

+ (UIColor*) separatorVertical;

+ (NSArray *) greenGradient;
+ (NSArray *) darkGrayGradient;
+ (NSArray *) grayGradient;

+ (UIColor *) rankingSelected;
+ (UIColor *) rankingOdd;
+ (UIColor *) rankingEven;

+ (UIColor *) darkGreen;

+ (UIColor *) credentialsBackground;
+ (UIColor *) credentialsSeparator;

+ (UIColor *) transparentWhite;

+ (UIColor *) settingsTextColor;

+ (NSArray *) timelineGradient;

+ (NSArray *) errorGradient;
+ (UIColor *) errorBorder;

+ (NSArray *) confirmationGradient;
+ (UIColor *) confirmationBorder;

+ (NSArray *) lightBlueGradient;
+ (NSArray *) doubledLightBlueGradient;

+ (UIColor*) segmentedControlSelected;
+ (UIColor*) backButtonColor;

@end
