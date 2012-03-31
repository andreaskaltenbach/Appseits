//
//  TimelineRoundSection.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineRoundSection.h"
#import "TournamentRound.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColors.h"
#import "SSGradientView.h"

#define ROUND_LABEL_HEIGHT 30
#define ROUND_LABEL_X 5
#define LOCK_ICON_MARGIN_RIGHT 5
#define LOCK_ICON_MARGIN_LEFT 5
#define LOCK_ICON_WIDTH 21

static UIImage *lockedImage;


@interface TimelineRoundSection()
@property (nonatomic, strong) TournamentRound *round;
@property (nonatomic, strong) SSGradientView *labelGradient;
@property (nonatomic, strong) UILabel *roundLabel;
@property (nonatomic, strong) UIImageView *lockImage;
@end

@implementation TimelineRoundSection

@synthesize round = _round;
@synthesize roundLabel = _roundLabel;
@synthesize lockImage = _lockImage;
@synthesize labelGradient = _labelGradient;

+ (void) initialize {
    lockedImage = [UIImage imageNamed:@"lockClosed.png"];
}

+ (TimelineRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent {
    
    float sectionWidth = 100 * [round.games count];
    float sectionHeight = parent.frame.size.height;
    float textIconDivider = sectionWidth - LOCK_ICON_WIDTH - LOCK_ICON_MARGIN_LEFT - LOCK_ICON_MARGIN_RIGHT;
    
    TimelineRoundSection *section = [[TimelineRoundSection alloc] initWithFrame:CGRectMake(0, 0, sectionWidth, sectionHeight)];
    section.round = round;
    
    // create the gradient view for the background of the round labels
    section.labelGradient = [[SSGradientView alloc] initWithFrame:CGRectMake(0, sectionHeight-ROUND_LABEL_HEIGHT, sectionWidth, ROUND_LABEL_HEIGHT)];
    section.labelGradient.colors = [UIColor menuGrayGradient];
    section.labelGradient.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [section addSubview:section.labelGradient];
    
    // create right border
    UIView *rightBorder = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth, 0, 1, sectionHeight)];
    rightBorder.backgroundColor = [UIColor grayColor];
    rightBorder.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [section addSubview:rightBorder];
    
    // place the label with round name inside the gradient view
    section.roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_LABEL_X, 0, textIconDivider - ROUND_LABEL_X, ROUND_LABEL_HEIGHT)];
    section.roundLabel.text = [round.roundName uppercaseString];
    section.roundLabel.font = [UIFont systemFontOfSize:12];
    section.roundLabel.backgroundColor = [UIColor clearColor];
    section.roundLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [section.labelGradient addSubview:section.roundLabel];
    
    // add an image view showing the lock
    section.lockImage = [[UIImageView alloc] initWithImage:lockedImage];
    section.lockImage.frame = CGRectMake(sectionWidth - LOCK_ICON_WIDTH - LOCK_ICON_MARGIN_RIGHT, (ROUND_LABEL_HEIGHT - LOCK_ICON_WIDTH)/2, LOCK_ICON_WIDTH, LOCK_ICON_WIDTH);
    section.lockImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [section.labelGradient addSubview:section.lockImage];
    
    [section addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:parent action:@selector(sectionTapped:)]];
    
    [parent addSubview:section];
    
    return section;
}

- (void) resize:(float) xOffset: (float) gameWidth {
    
    float width = [self.round.games count] * gameWidth;
    
    CGRect frame  = self.frame;
    frame.origin.x = xOffset;
    frame.size.width = width;
    self.frame = frame;
    
    //self
    
}

- (void) highlight {
    self.labelGradient.colors = [UIColor darkGrayGradient];
    self.roundLabel.textColor = [UIColor whiteColor];
}

- (void) unhighlight {
    self.labelGradient.colors = [UIColor menuGrayGradient];
    self.roundLabel.textColor = [UIColor blackColor];
}


@end
