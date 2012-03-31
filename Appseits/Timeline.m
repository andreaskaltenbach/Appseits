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
    NSMutableArray *separators = [NSMutableArray array];
    
    //self.totalWidth = self.frame.size.width;
    //float totalHeight = self.frame.size.height;
    
    // count all the games
    self.games = 0;
    for (TournamentRound *round in rounds) {
        self.games += [round.games count];
    }
    
        
    
    // add a section for each tournament round
    for (TournamentRound *round in rounds) {
        
        TimelineRoundSection *roundSection = [TimelineRoundSection initWithRound:round :self];
        [sections addObject:roundSection];
        
        /*// add the gradient behind the label
        UIView *gradient = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight-ROUND_LABEL_HEIGHT, sectionWidth, ROUND_LABEL_HEIGHT)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = gradient.bounds;
        gradientLayer.colors = [UIColor menuGrayGradient];
        [gradient.layer insertSublayer:gradientLayer atIndex:0]; 
        [roundSection addSubview:gradient];
        
        // add label with round name
        UILabel *roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(ROUND_LABEL_X, totalHeight-ROUND_LABEL_HEIGHT, sectionWidth - ROUND_LABEL_X, ROUND_LABEL_HEIGHT)];
        roundLabel.text = round.roundName;
        roundLabel.backgroundColor = [UIColor clearColor];
        NSLog(@"%@", round.roundName);
        
        // add a tap gesture handler for each individual section 
        [roundSection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)]];
        
        [roundSection addSubview:roundLabel];
        
        [self addSubview:roundSection];
        
        //[sectionToRoundMap setObject:round forKey:roundSection];
        
        xOffset += sectionWidth;*/
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
        UIView *section = sender.view;
        
        for (TimelineRoundSection *roundSection in self.timelineSections) {
            if (roundSection == section) {
                [roundSection highlight];
            }
            else {
                [roundSection unhighlight];
            }
        }
        [self setNeedsDisplay];
    }
}

@end
