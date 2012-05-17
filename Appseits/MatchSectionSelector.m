//
//  SectionSelector.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchSectionSelector.h"
#import "SSGradientView.h"
#import "UIColor+AppColors.h"
#import "LockImageProvider.h"
#import "TimelineRoundLabel.h"

#define TOTAL_HEIGHT 142
#define GRAPH_HEIGHT 100
#define SELECTOR_HEIGHT 132
#define GRADIENT_HEIGHT 32
#define BAR_HEIGHT 32


static UIImage* arrow;
static UIColor* leftUpperBorderColor;
static UIColor* leftLowerBorderColor;

@interface MatchSectionSelector()
@property (nonatomic, strong) TimelineRoundLabel *roundLabel;
@end

@implementation MatchSectionSelector

@synthesize roundLabel = _roundLabel;
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
        
        self.frame = CGRectMake(0, 0, referenceWidth, TOTAL_HEIGHT);
        
        self.backgroundColor = [UIColor clearColor];
        
        // create left border
        UIView *leftUpperBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, GRAPH_HEIGHT)];
        leftUpperBorder.backgroundColor = leftUpperBorderColor;
        [self addSubview:leftUpperBorder];
        
        // create round label
        self.roundLabel = [[TimelineRoundLabel alloc] init];
        self.roundLabel.frame = CGRectMake(0, GRAPH_HEIGHT, referenceWidth, GRADIENT_HEIGHT);
        self.roundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.roundLabel];
    }
    return self;
}

- (void) setRound:(MatchRound *)round {
    _round = round;
    self.roundLabel.round = round;
}

- (void) resize:(float) xOffset: (float) newWidth {
    CGRect frame  = self.frame;
    frame.origin.x = xOffset;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void) setSelected:(BOOL) selected {
    [self.roundLabel setSelected:selected];
}

@end
