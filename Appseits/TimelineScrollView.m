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
@end

@implementation TimelineScrollView

@synthesize tournamentRounds = _tournamentRounds;
@synthesize sections = _sections;
@synthesize roundSelectDelegate = _roundSelectDelegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize progressView = _progressView;
@synthesize orangeLine = _orangeLine;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToRight:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipe];
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToLeft:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;        
        [self addGestureRecognizer:rightSwipe];
        
        self.scrollEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
    }
    return self;
}

- (void) placeProgressWaves:(TimelineScrollViewRoundSection*) activeSection {
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
    
    self.contentSize = CGSizeMake([tournamentRounds count] * ROUND_WIDTH + 2*SIDE_OFFSET, self.frame.size.height);
    
    // add left-most space, which is always green
    UIView *beginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIDE_OFFSET, self.frame.size.height)];
    beginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lockedRound"]];
    [self addSubview:beginView];
    
    int xOffset = SIDE_OFFSET;
    
    // add one section for each tournament round
    NSMutableArray *sections = [NSMutableArray array];
    for (TournamentRound *tournamentRound in tournamentRounds) {
        TimelineScrollViewRoundSection *section = [TimelineScrollViewRoundSection initWithRound:tournamentRound :self];
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
    [self addSubview:self.progressView];
    
    self.orangeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, self.frame.size.height)];
    self.orangeLine.backgroundColor = [UIColor orangeLine];
    [self addSubview:self.orangeLine];
    
    [self placeProgressWaves:activeSection];

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


- (void) moveToRight:(UISwipeGestureRecognizer*) sender {
    if (self.selectedIndex + 1 < [self.sections count]) {
        TimelineScrollViewRoundSection *section = [self.sections objectAtIndex:self.selectedIndex + 1];
        [self selectTournamentRound:section];
    }
}

- (void) moveToLeft:(UISwipeGestureRecognizer*) sender {
    if (self.selectedIndex != 0) {
        TimelineScrollViewRoundSection *section = [self.sections objectAtIndex:self.selectedIndex - 1];
        [self selectTournamentRound:section];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"Scroll end: %f", scrollView.contentOffset.x);
}


@end
