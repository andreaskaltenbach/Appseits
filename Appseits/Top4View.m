//
//  Top4View.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4View.h"
#import "UIColor+AppColors.h"
#import "Top4Selector.h"

@interface Top4View()
@property (nonatomic, strong) NSArray *top4Selectors;
@end

@implementation Top4View

@synthesize top4Selectors = _top4Selectors;
@synthesize top4Round = _top4Round;
@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackBackground];
        
        self.top4Selectors = [NSArray arrayWithObjects: 
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"first"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"second"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"third"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"fourth"]],
                              nil];
        
        int yOffset = Y_OFFSET;
        for (Top4Selector *selector in self.top4Selectors) {
            selector.frame = CGRectMake(5, yOffset, 310, 50);    
            [self addSubview:selector];
            yOffset+= MARGIN;
        }
    }
    return self;
}

- (void)teamSelection:(UITapGestureRecognizer *)tapGesture {
    // call delegate to react on wish to select a team for top4 round
    int index = [self.top4Selectors indexOfObject:tapGesture.view];
    Top4Selector *teamSelector = [self.top4Selectors objectAtIndex:index];
    [self.delegate selectTeamFor:index + 1 currentSelection:teamSelector.team];
}

- (void) setTop4Round:(Top4Round *)top4Round {
    _top4Round = top4Round;
    
    [[self.top4Selectors objectAtIndex:0] setTeam:top4Round.top4Tips.firstTeam];
    [[self.top4Selectors objectAtIndex:1] setTeam:top4Round.top4Tips.secondTeam];
    [[self.top4Selectors objectAtIndex:2] setTeam:top4Round.top4Tips.thirdTeam];
    [[self.top4Selectors objectAtIndex:3] setTeam:top4Round.top4Tips.fourthTeam];
    
    if (!top4Round.open) {
        for (Top4Selector *selector in self.top4Selectors) {
            selector.locked = YES;
        }
    }
    else {
        for (Top4Selector *selector in self.top4Selectors) {
            [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamSelection:)]];
        }
    }
}

- (void) updatePlace:(int) place withTeam:(Team*) team: (FinishedBlock) onDone {
    
    // if team is already selected on other place, remove this prediction
    int duplicate = 0;
    if ([self.top4Round.top4Tips.firstTeam isEqual:team]) duplicate = 1;
    if ([self.top4Round.top4Tips.secondTeam isEqual:team]) duplicate = 2;
    if ([self.top4Round.top4Tips.thirdTeam isEqual:team]) duplicate = 3;
    if ([self.top4Round.top4Tips.fourthTeam isEqual:team]) duplicate = 4;
    if (duplicate > 0) {
        [BackendAdapter postPredictionForPlace:duplicate andTeam:0 :^(bool success) {
            if (success) {
                [self saveTeamPrediction:place :team :onDone];
            }
            else {
                onDone(NO);
            }
        }];
    } 
    else {
        [self saveTeamPrediction:place :team :onDone];
    }
}

- (void) saveTeamPrediction:(int) place:(Team*) team:(FinishedBlock) onDone {
    if (place == 1) self.top4Round.top4Tips.firstTeam = team;
    if (place == 2) self.top4Round.top4Tips.secondTeam = team;
    if (place == 3) self.top4Round.top4Tips.thirdTeam = team;
    if (place == 4) self.top4Round.top4Tips.fourthTeam = team;
    
    Top4Selector *selector = [self.top4Selectors objectAtIndex:place - 1];
    selector.team = team;
    
    // send update to server
    [BackendAdapter postPredictionForPlace:place andTeam:team.teamId :onDone];
}

@end
