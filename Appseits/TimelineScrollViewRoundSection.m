//
//  TimelineScrollViewRoundSection.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineScrollViewRoundSection.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"

#define LABEL_MARGIN_LEFT 10
#define LABEL_ICON_MARGIN 5
#define ICON_MARGIN_RIGHT 15
#define LABEL_WIDTH 85

#define LOCK_SIZE 24
#define LOCK_X_OFFSET 100

static UIImage *lockClosed;
static UIImage *lockClosedInset;
static UIImage *lockOpen;
static UIImage *lockOpenInset;
static UIImage *lockFuture;
static UIImage *lockFutureInset;

@interface TimelineScrollViewRoundSection()
@property (nonatomic, strong) SSGradientView *selectedGradient;
@property (nonatomic, strong) UIImageView *lockIcon;
@end

@implementation TimelineScrollViewRoundSection

@synthesize round = _round;
@synthesize selectedGradient = _selectedGradient;
@synthesize lockIcon = _lockIcon;

+ (void) initialize {
    lockClosed = [UIImage imageNamed:@"lockClosed"];
    lockClosedInset = [UIImage imageNamed:@"lockClosedInset"];
    lockOpen = [UIImage imageNamed:@"lockOpen"];
    lockOpenInset = [UIImage imageNamed:@"lockOpenInset"];
    lockFuture = [UIImage imageNamed:@"lockFuture"];
    lockFutureInset = [UIImage imageNamed:@"lockFutureInset"];
}

+ (TimelineScrollViewRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent {
    
    int sectionHeight = parent.frame.size.height;
    
    TimelineScrollViewRoundSection *section = [[TimelineScrollViewRoundSection alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH, sectionHeight)];
    
    // initialize selection gradient
    section.selectedGradient = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH, sectionHeight)];
    section.selectedGradient.colors = [UIColor selectedSection];
    [section addSubview:section.selectedGradient];
    
    // print round name
    UILabel *roundName = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_LEFT, 0, LABEL_WIDTH, sectionHeight)];
    roundName.text = round.roundName;
    roundName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    roundName.textColor = [UIColor whiteColor];
    roundName.font = [UIFont boldSystemFontOfSize:14];
    roundName.backgroundColor = [UIColor clearColor];
    [section addSubview:roundName];
    
    // initialize lock image
    section.lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(LOCK_X_OFFSET, (sectionHeight - LOCK_SIZE)/2, LOCK_SIZE, LOCK_SIZE)];
    [section addSubview: section.lockIcon];
        
    // add separator lines left and right
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 2, sectionHeight)];
    leftLine.backgroundColor = [UIColor separatorVertical];
    [section addSubview:leftLine];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH-1, 0, 2, sectionHeight)];
    rightLine.backgroundColor = [UIColor separatorVertical];
    [section addSubview:rightLine];
    
    [parent addSubview:section];
    
    section.round = round;
    
    return section;
}

- (void) setSelected:(BOOL) selected {
    if (selected) {
        self.selectedGradient.hidden = NO;
        self.lockIcon.image = [self selectedImage];
    }
    else {
        self.selectedGradient.hidden = YES;
        self.lockIcon.image = [self deselectedImage];
    }
}

- (UIImage*) selectedImage {
    switch (self.round.roundState) {
        case CLOSED:
            return lockClosedInset;
        case OPEN:
            return lockOpenInset;
        default:
            return lockFutureInset;
    }
}

- (UIImage*) deselectedImage {
    switch (self.round.roundState) {
        case CLOSED:
            return lockClosed;
        case OPEN:
            return lockOpen;
        default:
            return lockFuture;
    }
}

@end
