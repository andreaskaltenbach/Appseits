//
//  TimelineScrollViewRoundSection.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineScrollViewRoundSection.h"
#import "UIColor+AppColors.h"

#define LABEL_MARGIN_LEFT 10
#define LABEL_ICON_MARGIN 5
#define ICON_MARGIN_RIGHT 15
#define LABEL_WIDTH 85

static UIImage *lockedBackground;
static UIImage *unlockedBackground;

@interface TimelineScrollViewRoundSection()
@end

@implementation TimelineScrollViewRoundSection

@synthesize round = _round;

+ (void) initialize {
    lockedBackground = [UIImage imageNamed:@"lockedRound"];
    unlockedBackground = [UIImage imageNamed:@"openRound"];
}

+ (TimelineScrollViewRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent {
    
    int sectionHeight = parent.frame.size.height;
    
    TimelineScrollViewRoundSection *section = [[TimelineScrollViewRoundSection alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH, parent.frame.size.height)];
    
    // print round name
    UILabel *roundName = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_LEFT, 0, LABEL_WIDTH, sectionHeight)];
    roundName.text = round.roundName;
    roundName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    roundName.textColor = [UIColor whiteColor];
    roundName.font = [UIFont boldSystemFontOfSize:14];
    roundName.backgroundColor = [UIColor clearColor];
    [section addSubview:roundName];
    
    if (round.locked) {
        // show green background
        section.backgroundColor = [UIColor colorWithPatternImage:lockedBackground];
    }
    else {
        // show transparent background with gray lock
        section.backgroundColor = [UIColor colorWithPatternImage:unlockedBackground];
    }
        
    // add separator lines left and right
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, sectionHeight)];
    leftLine.backgroundColor = [UIColor separatorVertical];
    [section addSubview:leftLine];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH, 0, 1, sectionHeight)];
    rightLine.backgroundColor = [UIColor separatorVertical];
    [section addSubview:rightLine];
    
    [parent addSubview:section];
    
    section.round = round;
    
    [section addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:parent action:@selector(sectionTapped:)]];
    
    return section;
    
}

- (void) highlight {
    
}

- (void) unhighlight {
    
}

@end
