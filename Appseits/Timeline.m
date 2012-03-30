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

#define ROUND_LABEL_HEIGHT 30
#define ROUND_LABEL_X 10

@interface Timeline()
@property (nonatomic, strong) NSDictionary *sectionToRoundMap;
@property (nonatomic, strong) CAGradientLayer *activeGradientLayer;
@property (nonatomic, strong) CAGradientLayer *inactiveGradientLayer;
@end

@implementation Timeline

@synthesize rounds = _rounds;
@synthesize sectionToRoundMap = _sectionToRoundMap;
@synthesize activeGradientLayer = _activeGradientLayer;
@synthesize inactiveGradientLayer = _inactiveGradientLayer;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    return self;
}

-(void) setRounds:(NSArray *)rounds {
    _rounds = rounds;
    
    NSMutableDictionary *sectionToRoundMap = [NSMutableDictionary dictionary];
    
    float totalWidth = self.frame.size.width;
    float totalHeight = self.frame.size.height;
    
    float games = 0;
    for (TournamentRound *round in rounds) {
        games += [round.games count];
    }
    float widthPerGame = totalWidth/games;
    
    float xOffset = 0;
    
    // add a section for each round
    for (TournamentRound *round in rounds) {
        float sectionWidth = widthPerGame*[round.games count];
        UIView *roundSection = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, sectionWidth, totalHeight)];
        
        // add the gradient behind the label
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
        
        [sectionToRoundMap setObject:round forKey:roundSection];
        
        xOffset += sectionWidth;
    }
    
    self.sectionToRoundMap = sectionToRoundMap;
}

- (void) highlightSection: (UIView*) highlightedSection {
    __block TournamentRound *highlightedRound;
    
    [self.sectionToRoundMap enumerateKeysAndObjectsUsingBlock:^(UIView* section, TournamentRound* round, BOOL *stop) {
        

        if (section == highlightedSection) {
            // this section has to be highlighted
            highlightedRound = round;
            
        }
        else {
            // this section has to be inactive
            UIView *gradientView = [section.subviews objectAtIndex:1];
//            gradientView.layer
            
        }
        
    }];
    
    //return highlightedRound;
}
         
- (void) sectionTapped:(UITapGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView *section = sender.view;
                NSLog(@"Frame: %f", section.frame.size.width);
    }
}

@end
