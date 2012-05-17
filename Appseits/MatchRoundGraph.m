//
//  SectionSelector.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchRoundGraph.h"
#import "SSGradientView.h"
#import "UIColor+AppColors.h"
#import "LockImageProvider.h"
#import "TimelineRoundLabel.h"

#define GRAPH_HEIGHT 100

static UIImage* arrow;
static UIColor* leftUpperBorderColor;
static UIColor* leftLowerBorderColor;

@interface MatchRoundGraph()
@end

@implementation MatchRoundGraph

@synthesize round = _round;

+ (void) initialize {
    arrow = [UIImage imageNamed:@"selectionArrow"];
    leftUpperBorderColor = [UIColor colorWithRed:87.0/255.0f green:115.0f/255.0f blue:118.0f/255.0f alpha:1];
    //TODO - change color
    leftLowerBorderColor = [UIColor colorWithRed:87.0/255.0f green:115.0f/255.0f blue:118.0f/255.0f alpha:1];
}

- (id) init {
    self = [super init];
    if (self) {
        
        int referenceWidth = 100;
        
        self.frame = CGRectMake(0, 0, referenceWidth, GRAPH_HEIGHT);
        
        self.backgroundColor = [UIColor clearColor];
        
        // create left border
        UIView *leftUpperBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, GRAPH_HEIGHT)];
        leftUpperBorder.backgroundColor = leftUpperBorderColor;
        [self addSubview:leftUpperBorder];
    }
    return self;
}

- (void) resize:(float) xOffset: (float) newWidth {
    CGRect frame  = self.frame;
    frame.origin.x = xOffset;
    frame.size.width = newWidth;
    self.frame = frame;
}

@end
