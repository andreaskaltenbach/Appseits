//
//  TimelineScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineScrollView.h"
#import "UIColor+AppColors.h"
#import "MatchRound.h"
#import "TimelineScrollViewRoundSection.h"
#import "Match.h"

#define ROUND_TEXT_X 20
#define ROUND_TEXT_Y 4

#define ROUND_TEXT_HEIGHT 40
#define SIDE_OFFSET 100

static UIImage *darkLeft;
static UIImage *darkRight;

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

+ (void) initialize {
    darkLeft = [UIImage imageNamed:@"darkLeft"];
    darkRight = [UIImage imageNamed:@"darkRight"];
}

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

- (void) layoutProgressWaves:(TimelineScrollViewRoundSection*) lastClosedSection {
    float xPos = lastClosedSection.frame.origin.x;
    
    NSLog(@"Progress: %f", lastClosedSection.round.progress);
    xPos += ROUND_WIDTH * lastClosedSection.round.progress;
    
    self.progressView.frame = CGRectMake(0, 0, xPos, self.frame.size.height);
    self.orangeLine.frame = CGRectMake(xPos - 2, 0, 4, self.frame.size.height);
}

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    _tournamentRounds = tournamentRounds;
    
    float width = [tournamentRounds count] * ROUND_WIDTH + 2*SIDE_OFFSET;
    self.contentSize = CGSizeMake(width, self.frame.size.height);
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timelineBackground"]];
    [self addSubview:background]; 
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    [self addSubview:self.contentView];
    
    int xOffset = SIDE_OFFSET;
    
    // add one section for each tournament round
    NSMutableArray *sections = [NSMutableArray array];
    for (TournamentRound *tournamentRound in tournamentRounds) {
        TimelineScrollViewRoundSection *section = [TimelineScrollViewRoundSection initWithRound:tournamentRound :self.contentView];
        CGRect sectionFrame = section.frame;
        sectionFrame.origin.x = xOffset;
        section.frame = sectionFrame;
        [sections addObject:section];
        
        // add tap event for every section
        [section addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)]];
        
        xOffset += ROUND_WIDTH;
    }
    self.sections = [NSArray arrayWithArray:sections];
    
    // select current round
    TournamentRound* activeRound = [TournamentRound activeRound:self.tournamentRounds];
    
    TimelineScrollViewRoundSection *activeSection;
    for (TimelineScrollViewRoundSection *section in self.sections) {
        if (section.round == activeRound) {
            activeSection = section;
            [self selectSection:section];
        }
    }
    
    // put in the progress overlay
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    self.progressView.backgroundColor = [UIColor progressWaves];
    self.progressView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.progressView];
    
    self.orangeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, self.frame.size.height)];
    self.orangeLine.backgroundColor = [UIColor orangeLine];
    [self.contentView addSubview:self.orangeLine];
    
    TournamentRound *lastClosedRound = [TournamentRound lastClosedRound:self.tournamentRounds];
    for (TimelineScrollViewRoundSection *section in self.sections) {
        if (section.round == lastClosedRound) {
            [self layoutProgressWaves:section];
        }
    }
    
    [self setNeedsDisplay];
}



- (void) selectSection:(TimelineScrollViewRoundSection*) selectedSection {
    
    // unselect all sections and select the new one:
    for (TimelineScrollViewRoundSection *section in self.sections) {
        if (selectedSection != section) {
            [section setSelected:NO];
        }
        else {
            [section setSelected:YES];
        }
    }
    
    // scroll to the correct position:
    int totalWidth = self.frame.size.width;
    int xOffset = SIDE_OFFSET - (totalWidth - ROUND_WIDTH)/2;
    
    self.selectedIndex = [self.sections indexOfObject:selectedSection];
    [self scrollRectToVisible:CGRectMake(self.selectedIndex * ROUND_WIDTH + xOffset , 0, totalWidth, self.frame.size.height) animated:YES];
    
    [self.roundSelectDelegate tournamentRoundSelected:selectedSection.round];
}

- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        TimelineScrollViewRoundSection *section = (TimelineScrollViewRoundSection*) sender.view;
        [self selectSection:section];
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
            [self selectSection:section];
            return;
        }
    }
}

- (void) selectTournamentRound:(TournamentRound*) round {
    
    for (TimelineScrollViewRoundSection *section in self.sections) {
        if (section.round == round) {
            [self selectSection:section];
        }
    }
}


@end
