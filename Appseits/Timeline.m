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
#import "MatchRoundGraph.h"

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
        [sectionWidth.section resize:xOffset :sectionWidth.width];
        xOffset+= sectionWidth.width;
    }
}

-(void) setMatchRounds:(NSArray *)matchRounds {
    _matchRounds = matchRounds;
    
    
    NSMutableArray *sections = [NSMutableArray array];
    
    // add a section selector for each match round
    for (MatchRound *matchRound in matchRounds) {
        MatchRoundGraph *sectionSelector = [[MatchRoundGraph alloc] init];
        sectionSelector.round = matchRound;
        [self addSubview:sectionSelector];
        [sections addObject:sectionSelector];
    }
    self.timelineSections = sections;
    
    [self layoutSections];
    [self setNeedsDisplay];
}
         
@end
