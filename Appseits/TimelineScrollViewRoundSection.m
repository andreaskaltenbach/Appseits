//
//  TimelineScrollViewRoundSection.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineScrollViewRoundSection.h"
#import "UIColor+AppColors.h"
#define LABEL_MARGIN_LEFT 5
#define LABEL_ICON_MARGIN 5
#define BALL_WIDTH 26
#define LOCK_WIDTH 15
#define ICON_MARGIN_RIGHT 5
#define ROUND_MIN_WIDTH 100


static UIImage *greenBall;
static UIImage *grayBall;
static UIImage *lockOpen;
static UIImage *lockClosed;

@interface TimelineScrollViewRoundSection()
@end

@implementation TimelineScrollViewRoundSection

@synthesize round = _round;

+ (void) initialize {
    greenBall = [UIImage imageNamed:@"greenBall"];
    grayBall = [UIImage imageNamed:@"grayBall"];
    lockOpen = [UIImage imageNamed:@"lockOpen"];
    lockClosed = [UIImage imageNamed:@"lockClosed"];
}

+ (TimelineScrollViewRoundSection*) initWithRound:(TournamentRound*) round: (UIView*) parent {
    float sectionHeight = parent.frame.size.height;
    float sectionWidth = 100 * [round.games count];
    TimelineScrollViewRoundSection *section = [[TimelineScrollViewRoundSection alloc] initWithFrame:CGRectMake(0, 0, sectionWidth, sectionHeight)];
    
    // print round name
    UILabel *roundName = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN_LEFT, 0, sectionWidth - ICON_MARGIN_RIGHT - BALL_WIDTH - LABEL_ICON_MARGIN, sectionHeight)];
    roundName.text = round.roundName;
    roundName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (round.locked) {
        roundName.textColor = [UIColor highlightedGreen];
    }
    else {
        roundName.textColor = [UIColor whiteColor];
    }
    roundName.font = [UIFont systemFontOfSize:20];
    roundName.backgroundColor = [UIColor clearColor];
    [section addSubview:roundName];
    
    // add the lock icon
    UIImageView *ball;
    UIImageView *lock;
    if (round.locked) {
        ball = [[UIImageView alloc]initWithImage:greenBall];   
        lock = [[UIImageView alloc]initWithImage:lockClosed];   
    }
    else {
        ball = [[UIImageView alloc]initWithImage:grayBall];   
        lock = [[UIImageView alloc]initWithImage:lockOpen];
    }
    ball.frame = CGRectMake(sectionWidth - BALL_WIDTH - ICON_MARGIN_RIGHT, (sectionHeight - BALL_WIDTH)/2, BALL_WIDTH, BALL_WIDTH);
    ball.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    lock.frame = CGRectMake(sectionWidth - 5 - BALL_WIDTH + (BALL_WIDTH - LOCK_WIDTH) - ICON_MARGIN_RIGHT, (sectionHeight - LOCK_WIDTH)/2, LOCK_WIDTH, LOCK_WIDTH);
    lock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [section addSubview:ball];
    [section addSubview:lock];
    
    // add separator line as right border
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth, 0, 1, sectionHeight)];
    line.backgroundColor = [UIColor separatorVertical];
    line.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [section addSubview:line];
    
    [section addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:parent action:@selector(sectionTapped:)]];
    [parent addSubview:section];
    
    section.round = round;
    
    return section;
    
}

- (void) resize:(float) offset: (float) gameWidth {
    float sectionWidth = gameWidth * [self.round.games count];
    if (sectionWidth < ROUND_MIN_WIDTH) {
        sectionWidth = ROUND_MIN_WIDTH;
    }
    
    CGRect frame = self.frame;
    frame.size.width = sectionWidth;
    frame.origin.x = offset;
    self.frame = frame;
    

}

- (void) highlight {
    
}

- (void) unhighlight {
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
