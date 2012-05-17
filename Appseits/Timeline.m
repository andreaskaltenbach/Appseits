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
#import "TimelineRoundSection.h"
#import "SSGradientView.h"
#import "SectionWidth.h"

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
        
    }
    return self;
}
/*

    
    float xOffset = TOP4_AND_SCORER_OFFSET;
    float widthPerGame = frame.size.width/self.games;

    for (TimelineRoundSection *section in self.subviews) {
        
        if ([section isKindOfClass:[TimelineRoundSection class]]) {
            [section resize:xOffset :widthPerGame];
            xOffset += section.frame.size.width;
        }
    }
    
    
}*/



- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
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
    
    
    //NSArray* sectionPercentages = [self getSectionPercentages];
    
    
    
    
    NSMutableArray *sections = [NSMutableArray array];
    
    

    // add a section for each tournament round
    for (MatchRound *matchRound in matchRounds) {
        TimelineRoundSection *roundSection = [TimelineRoundSection initWithRound:matchRound :self];
        [sections addObject:roundSection];
    }
    self.timelineSections = sections;
    
    // create left border
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    leftBorder.backgroundColor = [UIColor grayColor];
    [self addSubview:leftBorder];
    
    [self selectTournamentRound:[self.timelineSections objectAtIndex:0]];
    
    [self setNeedsDisplay];
}

- (void) selectTournamentRound:(TimelineRoundSection*) section {
    for (TimelineRoundSection *roundSection in self.timelineSections) {
        if (roundSection == section) {
            [roundSection highlight];
        }
        else {
            [roundSection unhighlight];
        }
    }
    [self setNeedsDisplay];
    
    [self.roundSelectDelegate tournamentRoundSelected:section.round];
}
         
- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        TimelineRoundSection *section = (TimelineRoundSection*) sender.view;
        [self selectTournamentRound:section];
    }
}

@end
