//
//  Timeline.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Timeline.h"
#import "TournamentRound.h"
#import "Game.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>
#import "TimelineRoundSection.h"
#import "SSGradientView.h"

#define ROUND_LABEL_HEIGHT 30

@interface Timeline()
@property (nonatomic, strong) NSArray *timelineSections;
@property (nonatomic, strong) UIView *roundLabelGradient;
@property (nonatomic, strong) NSArray *separators;
@property float totalWidth;
@property int games;
@end

@implementation Timeline

@synthesize rounds = _rounds;
@synthesize timelineSections = _timelineSections;
@synthesize totalWidth = _totalWidth;
@synthesize games = _games;
@synthesize roundLabelGradient = _roundLabelGradient;
@synthesize separators = _separators;
@synthesize roundSelectDelegate =  _roundSelectDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (void) drawRect:(CGRect)rect {
    
    float xOffset = 0;
    float widthPerGame = rect.size.width/self.games;

    for (TimelineRoundSection *section in self.subviews) {
        
        if ([section isKindOfClass:[TimelineRoundSection class]]) {
            [section resize:xOffset :widthPerGame];
            xOffset += section.frame.size.width;
        }
    }
    
    [super drawRect:rect];
}

-(void) setRounds:(NSArray *)rounds {
    _rounds = rounds;
    
    NSMutableArray *sections = [NSMutableArray array];
    
    // count all the games
    self.games = 0;
    for (TournamentRound *round in rounds) {
        self.games += [round.games count];
    }

    // add a section for each tournament round
    for (TournamentRound *round in rounds) {
        TimelineRoundSection *roundSection = [TimelineRoundSection initWithRound:round :self];
        [sections addObject:roundSection];
    }
    self.timelineSections = sections;
    
    // create left border
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    leftBorder.backgroundColor = [UIColor grayColor];
    [self addSubview:leftBorder];
    
    [self setNeedsDisplay];
}

         
- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        TimelineRoundSection *section = (TimelineRoundSection*) sender.view;
        
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
}

@end
