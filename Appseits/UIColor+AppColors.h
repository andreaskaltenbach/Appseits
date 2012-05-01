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
+ (UIColor*) headerBackground;

+ (UIColor*) menuBackground;
+ (UIColor*) menuSelectedBackground;

+ (NSArray *) grayBackgroundGradient;

+ (UIColor*) blackBackground;

+ (UIColor*) squareBackground;

+ (UIColor*) highlightedGreen;

+ (NSArray *) gameCellGradient;

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
@end
