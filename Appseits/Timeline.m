//
//  Timeline.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Timeline.h"
#import "MatchRound.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>
#import "SSGradientView.h"
#import "SectionWidth.h"
#import "MatchSectionSelector.h"

#define ROUND_LABEL_HEIGHT 30

#define TOP4_AND_SCORER_OFFSET 120

@interface Timeline()
@property (nonatomic, strong) NSArray *timelineSections;
@property (nonatomic, strong) UIView *roundLabelGradient;
@property (nonatomic, strong) NSArray *separators;
@property float totalWidth;
@property int games;

@property (nonatomic, strong) NSArray *sectionPercentages;
@end

@implementation Timeline

@synthesize matchRounds = _matchRounds;
@synthesize timelineSections = _timelineSections;
@synthesize totalWidth = _totalWidth;
@synthesize games = _games;
@synthesize roundLabelGradient = _roundLabelGradient;
@synthesize separators = _separators;
@synthesize roundSelectDelegate =  _roundSelectDelegate;
@synthesize sectionPercentages = _sectionPercentages;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self layoutSections];
}

- (void) layoutSections {
    NSArray *sectionWidths = [SectionWidth sectionWidths:self.timelineSections :self.frame.size.width];
    
    // resize all sections
    float xOffset = 0;
    for (SectionWidth *sectionWidth in sectionWidths) {
        NSLog(@"Section: offset: %f, width: %f", xOffset, sectionWidth.width);
        [sectionWidth.section resize:xOffset :sectionWidth.width];
        xOffset+= sectionWidth.width;
    }
}

-(void) setMatchRounds:(NSArray *)matchRounds {
    _matchRounds = matchRounds;
    
    
    NSMutableArray *sections = [NSMutableArray array];
    
    // add a section selector for each match round
    for (MatchRound *matchRound in matchRounds) {
        MatchSectionSelector *sectionSelector = [[MatchSectionSelector alloc] init];
        sectionSelector.round = matchRound;
        [sectionSelector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)]];
        [self addSubview:sectionSelector];
        [sections addObject:sectionSelector];
    }
    self.timelineSections = sections;
    
       
    [self selectMatchRound:[self.timelineSections objectAtIndex:0]];
    
    [self layoutSections];
    [self setNeedsDisplay];
}

- (void) selectMatchRound:(MatchSectionSelector*) sectionSel {
   for (MatchSectionSelector *sectionSelector in self.timelineSections) {
        if (sectionSelector == sectionSel) {
            [sectionSelector setSelected:YES];
        }
        else {
            [sectionSelector setSelected:NO];
        }
    }
    
    [self.roundSelectDelegate tournamentRoundSelected:sectionSel.round];
}
         
- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        MatchSectionSelector *sectionSelector = (MatchSectionSelector*) sender.view;
        [self selectMatchRound:sectionSelector];
    }
}

@end
