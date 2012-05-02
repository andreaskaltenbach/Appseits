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
#import "Match.h"

#define ROUND_TEXT_X 20
#define ROUND_TEXT_Y 4

#define ROUND_TEXT_HEIGHT 40
#define SIDE_OFFSET 100

@interface TimelineScrollView()
@property (nonatomic, strong) NSArray *sections;
@property int selectedIndex;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *orangeLine;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TimelineScrollView

@synthesize tournamentRounds = _tournamentRounds;
@synthesize sections = _sections;
@synthesize roundSelectDelegate = _roundSelectDelegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize progressView = _progressView;
@synthesize orangeLine = _orangeLine;
@synthesize contentView = _myContentView;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.scrollEnabled = YES;
        self.scrollsToTop = NO;
        self.bounces = NO;
        self.delegate = self;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void) layoutProgressWaves:(TimelineScrollViewRoundSection*) activeSection {
    float xPos = activeSection.frame.origin.x;
    
    // go through all matches in a round until the first unfinished is found
    float matchWidth = activeSection.frame.size.width / [activeSection.round.matches count];
    for (Match* match in activeSection.round.matches) {
        xPos+= matchWidth;
        if (!match.finished) {
            self.progressView.frame = CGRectMake(0, 0, xPos, self.frame.size.height);
            self.orangeLine.frame = CGRectMake(xPos - 2, 0, 4, self.frame.size.height);
            return;
        }
    }
    self.progressView.frame = CGRectMake(0, 0, activeSection.frame.origin.x, self.frame.size.height);
    self.orangeLine.frame = CGRectMake(activeSection.frame.origin.x, 0, 4, self.frame.size.height);
}

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    _tournamentRounds = tournamentRounds;
    
    float width = [tournamentRounds count] * ROUND_WIDTH + 2*SIDE_OFFSET;
    self.contentSize = CGSizeMake(width, self.frame.size.height);
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    [self addSubview:self.contentView];
    
    // add left-most space, which is always green
    UIView *beginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIDE_OFFSET, self.frame.size.height)];
    beginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lockedRound"]];
    [self.contentView addSubview:beginView];
    
    int xOffset = SIDE_OFFSET;
    
    // add one section for each tournament round
    NSMutableArray *sections = [NSMutableArray array];
    for (TournamentRound *tournamentRound in tournamentRounds) {
        TimelineScrollViewRoundSection *section = [TimelineScrollViewRoundSection initWithRound:tournamentRound :self.contentView];
        CGRect sectionFrame = section.frame;
        sectionFrame.origin.x = xOffset;
        section.frame = sectionFrame;
        [sections addObject:section];
        
        xOffset += ROUND_WIDTH;
    }
    self.sections = [NSArray arrayWithArray:sections];
    
    // select current round
    TimelineScrollViewRoundSection *activeSection;
    for (TimelineScrollViewRoundSection *section in self.sections) {
        if (section.round.isActive) {
            activeSection = section;
        }
    }
    
    // if no active section can be identified, we take the first one
    if (!activeSection) activeSection = [self.sections objectAtIndex:0];
    
    // TODO better logic to decide which round to select initially
    [self selectTournamentRound:activeSection];
    
    
    // put in the progress overlay
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    self.progressView.backgroundColor = [UIColor progressWaves];
    [self.contentView addSubview:self.progressView];
    
    self.orangeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, self.frame.size.height)];
    self.orangeLine.backgroundColor = [UIColor orangeLine];
    [self.contentView addSubview:self.orangeLine];
    
    [self layoutProgressWaves:activeSection];

    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.sections) {
        TimelineScrollViewRoundSection *section = [self.sections objectAtIndex:self.selectedIndex];
        [self selectTournamentRound:section];
    }
}

- (void) selectTournamentRound:(TimelineScrollViewRoundSection*) section {
    
    // scroll to the correct position:
    int totalWidth = self.frame.size.width;
    int xOffset = SIDE_OFFSET - (totalWidth - ROUND_WIDTH)/2;
    
    self.selectedIndex = [self.sections indexOfObject:section];
    [self scrollRectToVisible:CGRectMake(self.selectedIndex * ROUND_WIDTH + xOffset , 0, totalWidth, self.frame.size.height) animated:YES];
    
    [self.roundSelectDelegate tournamentRoundSelected:section.round];
}

- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        TimelineScrollViewRoundSection *section = (TimelineScrollViewRoundSection*) sender.view;
        [self selectTournamentRound:section];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    int halfSectionSize = ROUND_WIDTH/2;
    
    int xOffset = (self.frame.size.width - ROUND_WIDTH) / 2;

    
    // get closest tournament round and scroll to this:
    for (TimelineScrollViewRoundSection *section in self.sections) {
        int leftBoundary = section.frame.origin.x - halfSectionSize - xOffset;
        int rightBoundary = section.frame.origin.x + halfSectionSize - xOffset;
        
        if (leftBoundary < scrollView.contentOffset.x &&
            scrollView.contentOffset.x < rightBoundary) {
            targetContentOffset->x =  section.frame.origin.x - xOffset;
            [self selectTournamentRound:section];
            return;
        }
    }
}


@end
