//
//  TimelineScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineScrollView.h"
#import "UIColor+AppColors.h"
#import "TournamentRound.h"

#define ROUND_WIDTH_IN_TIMELINE 250
#define ROUND_TEXT_X 20
#define ROUND_TEXT_Y 10
#define ROUND_TEXT_WIDTH 140
#define ROUND_TEXT_HEIGHT 40

@implementation TimelineScrollView

@synthesize tournamentRounds = _tournamentRounds;

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    _tournamentRounds = tournamentRounds;
    
    int height = self.frame.size.height;
    
    self.contentSize = CGSizeMake([tournamentRounds count] * ROUND_WIDTH_IN_TIMELINE, height);
    
    int xOffset = 0;
    for (TournamentRound *tournamentRound in tournamentRounds) {
        
        if (xOffset != 0) {
            // draw line
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, 1, height)];
            line.backgroundColor = [UIColor blueColor];
            [self addSubview:line];
        }
        
        // print round name
        UILabel *roundName = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + ROUND_TEXT_X, ROUND_TEXT_Y, ROUND_TEXT_WIDTH, ROUND_TEXT_HEIGHT)];
        roundName.text = tournamentRound.roundName;
        roundName.textAlignment = UITextAlignmentCenter;
        if (tournamentRound.locked) {
            roundName.textColor = [UIColor highlightedGreen];
        }
        else {
            roundName.textColor = [UIColor whiteColor];
        }
        roundName.font = [UIFont systemFontOfSize:20];
        roundName.backgroundColor = [UIColor clearColor];
        
        [self addSubview:roundName];
        
        xOffset+= ROUND_WIDTH_IN_TIMELINE;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end
