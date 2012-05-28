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
@synthesize overviewViewController = _overviewViewController;

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
        
        for (ScorerSelector *selector in self.scorerSelectors) {
            [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerSelection:)]];
        }
        
        int yOffset = Y_OFFSET + 20;
        for (ScorerSelector *selector in self.scorerSelectors) {
            selector.frame = CGRectMake(5, yOffset, 310, 50);    
            [self addSubview:selector];
            yOffset+= MARGIN;
        }
    }
    return self;
}

- (void)playerSelection:(UITapGestureRecognizer *)tapGesture {
    
    if (self.scorerRound.notPassed) {
        // call delegate to react on wish to select a player for scorer round
        int index = [self.scorerSelectors indexOfObject:tapGesture.view];
        ScorerSelector *scorerSelector = [self.scorerSelectors objectAtIndex:index];
        [self.delegate selectPlayerFor:index + 1 currentSelection:scorerSelector.player];
    } 
    else {
        // top 4 round is closed -> show error message
        [self.overviewViewController showError:@"Denna omgång är stängd."];
    }
}

- (void) setScorerRound:(ScorerRound *)scorerRound {
    _scorerRound = scorerRound;
    
    [[self.scorerSelectors objectAtIndex:0] setPlayer:scorerRound.scorerTips.firstPlayer];
    [[self.scorerSelectors objectAtIndex:1] setPlayer:scorerRound.scorerTips.secondPlayer];
    [[self.scorerSelectors objectAtIndex:2] setPlayer:scorerRound.scorerTips.thirdPlayer];
    
    if (!scorerRound.notPassed) {
        for (ScorerSelector *selector in self.scorerSelectors) {
            selector.locked = YES;
        }
    }
}

- (void) updatePlace:(int) place withPlayer:(Player*) player: (RemoteCallBlock) remoteCallBlock {
    
    // if team is already selected on other place, remove this prediction
    int duplicate = 0;
    if ([self.scorerRound.scorerTips.firstPlayer isEqual:player] && place != 1) {
        duplicate = 1;
        self.scorerRound.scorerTips.firstPlayer = nil;
    }
    if ([self.scorerRound.scorerTips.secondPlayer isEqual:player]&& place != 2) {
        duplicate = 2;   
        self.scorerRound.scorerTips.secondPlayer = nil;
    }
    if ([self.scorerRound.scorerTips.thirdPlayer isEqual:player] && place != 3) {
        duplicate = 3;    
        self.scorerRound.scorerTips.thirdPlayer = nil;
    }
    if (duplicate > 0) {
        ScorerSelector *selectorToClean = [self.scorerSelectors objectAtIndex:(duplicate-1)];
        selectorToClean.player = nil;
        [BackendAdapter postPredictionForPlace:duplicate andPlayer:[NSNumber numberWithInt:0] :^(RemoteCallResult remoteCallResult) {
            
            if (remoteCallResult == OK) {
                [self savePlayerPrediction:place :player :remoteCallBlock];
            }
            else {
                remoteCallBlock(remoteCallResult);
            }
        }];
    } 
    else {
        [self savePlayerPrediction:place :player :remoteCallBlock];
    }
}

- (void) savePlayerPrediction:(int) place:(Player*) player:(RemoteCallBlock) remoteCallBlock {
    if (place == 1) self.scorerRound.scorerTips.firstPlayer = player;
    if (place == 2) self.scorerRound.scorerTips.secondPlayer = player;
    if (place == 3) self.scorerRound.scorerTips.thirdPlayer = player;
    
    ScorerSelector *selector = [self.scorerSelectors objectAtIndex:place - 1];
    selector.player = player;
    
    // send update to server
    [BackendAdapter postPredictionForPlace:place andPlayer:player.playerId :remoteCallBlock];
}

@end
