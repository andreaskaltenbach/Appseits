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
#import "TimelineScrollViewRoundSection.h"

#define ROUND_TEXT_X 20
#define ROUND_TEXT_Y 4
#define ROUND_TEXT_WIDTH 140
#define ROUND_TEXT_HEIGHT 40
#define MATCH_WIDTH 35

@interface TimelineScrollView()
@property (nonatomic, strong) NSArray *sections;

@end

@implementation TimelineScrollView

@synthesize tournamentRounds = _tournamentRounds;
@synthesize sections = _sections;

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    _tournamentRounds = tournamentRounds;
    
    int height = self.frame.size.height;
    
    // add progress waves
    int progressWidth = 200;
    UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, progressWidth, self.frame.size.height)];
    progress.backgroundColor = [UIColor progressWaves];
    [self addSubview:progress];
    UIView *orangeSeparator = [[UIView alloc] initWithFrame:CGRectMake(progressWidth, 0, 2, self.frame.size.height)];
    orangeSeparator.backgroundColor = [UIColor orangeSeparator];
    [self addSubview:orangeSeparator];
    
    // add one section for each tournament round
    NSMutableArray *sections = [NSMutableArray array];
    for (TournamentRound *tournamentRound in tournamentRounds) {
        TimelineScrollViewRoundSection *section = [TimelineScrollViewRoundSection initWithRound:tournamentRound :self];
        [sections addObject:section];
    }
    self.sections = [NSArray arrayWithArray:sections];
    
    // add separator line as left border
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, height)];
    line.backgroundColor = [UIColor separatorVertical];
    line.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:line];

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    int offset = 0;
    
    // resize all sections
    for (TimelineScrollViewRoundSection *section in self.sections) {
        [section resize:offset :MATCH_WIDTH];
        offset += section.frame.size.width;
    }
    
    CGSize contentSize = self.contentSize;
    contentSize.width = offset;
    self.contentSize = contentSize;
    
    [super drawRect:rect];
}


@end
