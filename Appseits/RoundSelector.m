//
//  RoundSelector.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundSelector.h"
#import "TimelineRoundLabel.h"
#import "BackendAdapter.h"
#import "SectionWidth.h"
#import "TournamentRoundSelectDelegate.h"

#define TOP4_SCORER_WIDTH 170

@interface RoundSelector()
@property (nonatomic, strong) NSMutableArray* roundLabels;
@property (nonatomic, strong) NSMutableArray* flexibleRoundLabels;

@end

@implementation RoundSelector

@synthesize tournamentRounds = _tournamentRounds;
@synthesize roundLabels = _roundLabels;
@synthesize flexibleRoundLabels = _flexibleRoundLabels;
@synthesize roundSelectDelegate =  _roundSelectDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.roundLabels = [NSMutableArray array];
        self.flexibleRoundLabels = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setTournamentRounds:(NSArray *)tournamentRounds {
    _tournamentRounds = tournamentRounds;
    
    for (TournamentRound* tournamentRound in tournamentRounds) {
    
        TimelineRoundLabel *roundLabel = [[TimelineRoundLabel alloc] initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height)];
        roundLabel.round = tournamentRound;
        [self.roundLabels addObject:roundLabel];
 
        // add all but the first round to the list of flexible round labels
        if ([tournamentRounds indexOfObject:tournamentRound] != 0) {
            [self.flexibleRoundLabels addObject:roundLabel];
        }
        
        [self addSubview:roundLabel];
        [roundLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roundTapped:)]];
    }
    
    // the first round (top4 and scorer) has always the same width
    TimelineRoundLabel* top4AndScorerRound = [self.roundLabels objectAtIndex:0];
    CGRect frame = top4AndScorerRound.frame;
    frame.size.width = TOP4_SCORER_WIDTH;
    top4AndScorerRound.frame = frame;
    
    TournamentRound* activeRound = [TournamentRound activeRound:self.tournamentRounds];
    for (TimelineRoundLabel *roundLabel in self.roundLabels) {
        if (roundLabel.round == activeRound) {
            [roundLabel setSelected:YES];
        }
        else {
            [roundLabel setSelected:NO];
        }
    }
    
    [self layoutSections];
    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self layoutSections];
}

- (void) layoutSections {
    
    float remainingWidth = self.frame.size.width - TOP4_SCORER_WIDTH;
    
    NSArray *sectionWidths = [SectionWidth sectionWidths:self.flexibleRoundLabels :remainingWidth];
    
    // resize all sections
    float xOffset = TOP4_SCORER_WIDTH;
    for (SectionWidth *sectionWidth in sectionWidths) {
        NSLog(@"Section: offset: %f, width: %f", xOffset, sectionWidth.width);
        [sectionWidth.section resize:xOffset :sectionWidth.width];
        xOffset+= sectionWidth.width;
    }
}

- (void) roundTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        TimelineRoundLabel *roundLabel = (TimelineRoundLabel*) sender.view;
        [self selectTournamentRound:roundLabel];
    }
}

- (void) selectTournamentRound:(TimelineRoundLabel*) selectedLabel {
    for (TimelineRoundLabel *label in self.roundLabels) {
        if (label == selectedLabel) {
            [label setSelected:YES];
        }
        else {
            [label setSelected:NO];
        }
    }
    
    [self.roundSelectDelegate tournamentRoundSelected:selectedLabel.round];
}


@end
