//
//  TimelineRoundLabel.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TimelineRoundLabel.h"
#import "SSGradientView.h"
#import "UIColor+AppColors.h"
#import "LockImageProvider.h"

#define HEIGHT 42
#define LOCK_SIZE 24
#define LOCK_RIGHT_MARGIN 5
#define GRADIENT_HEIGHT 32

@interface TimelineRoundLabel()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) SSGradientView *gradientView;
@property (nonatomic, strong) UIImageView *lockView;
@end

@implementation TimelineRoundLabel

static UIImage* arrow;
static UIColor* leftBorderColor;

@synthesize arrowView = _arrowView;
@synthesize lockView = _lockView;
@synthesize round = _round;
@synthesize gradientView = _gradientView;
@synthesize label = _label;

+ (void) initialize {
    arrow = [UIImage imageNamed:@"selectionArrow"];
    //TODO - change color
    leftBorderColor = [UIColor colorWithRed:87.0/255.0f green:115.0f/255.0f blue:118.0f/255.0f alpha:1];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"%f, %f", self.frame.size.height, self.frame.size.width);
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initLabel];
        
    }
    return self;
}

- (void) initLabel {
    // add gradient view 
    self.gradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width + 10, GRADIENT_HEIGHT)];
    self.gradientView.colors = [UIColor timelineGradient];
    self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.gradientView];
    
    // add round text inside gradient
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - LOCK_SIZE - 3*LOCK_RIGHT_MARGIN, GRADIENT_HEIGHT)];
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    
    // add lock image
    self.lockView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - LOCK_RIGHT_MARGIN - LOCK_SIZE , (GRADIENT_HEIGHT - LOCK_SIZE) / 2, LOCK_SIZE, LOCK_SIZE)],
    self.lockView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:self.lockView];
    
    // the last 10px are reserved for the arrow
    self.arrowView = [[UIImageView alloc] initWithImage:arrow];
    self.arrowView.hidden = YES;
    self.arrowView.frame = CGRectMake((self.frame.size.width - arrow.size.width)/2, GRADIENT_HEIGHT, arrow.size.width, arrow.size.height);
    self.arrowView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview: self.arrowView];
}

- (id)init {
    self = [super init];

    if (self) {
        int referenceWidth = 100;
        self.frame = CGRectMake(0, 0, referenceWidth, HEIGHT);
        
        [self initLabel];
                
        UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, GRADIENT_HEIGHT)];
        leftBorder.backgroundColor = leftBorderColor;
        [self addSubview:leftBorder];
   
    }
    return self;
}

- (void) setRound:(TournamentRound *)round {
    _round = round;
    self.label.text = [round.roundName uppercaseString];
}

- (void) setSelected:(BOOL) selected {
    
    if (selected) {
        self.gradientView.colors = [UIColor selectedSection];
        self.arrowView.hidden = NO;
    }
    else {
        self.gradientView.colors = [UIColor timelineGradient];
        self.arrowView.hidden = YES;
    }
    
    self.lockView.image = [LockImageProvider imageForTournamentRound:self.round :selected];
}


@end
