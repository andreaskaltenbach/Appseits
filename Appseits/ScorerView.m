//
//  ScorerView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerView.h"
#import "UIColor+AppColors.h"
#import "ScorerSelector.h"
#import "Top4View.h"

@interface ScorerView()
@property (nonatomic, strong) NSArray *scorerSelectors;
@end

@implementation ScorerView

@synthesize scorerRound = _scorerRound;
@synthesize delegate = _delegate;
@synthesize scorerSelectors = _scorerSelectors;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackBackground];
        
        self.scorerSelectors = [NSArray arrayWithObjects: 
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              nil];
        
        int yOffset = Y_OFFSET + 20;
        for (ScorerSelector *selector in self.scorerSelectors) {
            selector.frame = CGRectMake(5, yOffset, 310, 50);    
            [self addSubview:selector];
            
            if (self.scorerRound.open) {
                [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerSelection:)]];
            }
            
            yOffset+= MARGIN;
        }
    }
    return self;
}

- (void)playerSelection:(UITapGestureRecognizer *)tapGesture {
    // call delegate to react on wish to select a player for scorer round
    int index = [self.scorerSelectors indexOfObject:tapGesture.view];
    ScorerSelector *scorerSelector = [self.scorerSelectors objectAtIndex:index];
    [self.delegate selectPlayerFor:index + 1 currentSelection:scorerSelector.player];
}

- (void) setScorerRound:(ScorerRound *)scorerRound {
    _scorerRound = scorerRound;
    
    [[self.scorerSelectors objectAtIndex:0] setPlayer:scorerRound.scorerTips.firstPlayer];
    [[self.scorerSelectors objectAtIndex:1] setPlayer:scorerRound.scorerTips.secondPlayer];
    [[self.scorerSelectors objectAtIndex:2] setPlayer:scorerRound.scorerTips.thirdPlayer];
    
    if (!scorerRound.open) {
        for (ScorerSelector *selector in self.scorerSelectors) {
            selector.locked = YES;
        }
    }
}

- (void) updatePlace:(int) place withPlayer:(Player*) player: (FinishedBlock) onDone {
    
    if (place == 1) self.scorerRound.scorerTips.firstPlayer = player;
    if (place == 2) self.scorerRound.scorerTips.secondPlayer = player;
    if (place == 3) self.scorerRound.scorerTips.thirdPlayer = player;
    
    ScorerSelector *selector = [self.scorerSelectors objectAtIndex:place - 1];
    selector.player = player;
    
    // send update to server
    [BackendAdapter postPredictionForPlace:place andPlayer:player.playerId :onDone];
}

@end
