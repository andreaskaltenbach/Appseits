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
@synthesize overviewViewController = _overviewViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackBackground];
        
        self.top4Selectors = [NSArray arrayWithObjects: 
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"first"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"second"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"third"]],
                              [[Top4Selector alloc] init:[UIImage imageNamed:@"third"]],
                              nil];
        for (Top4Selector *selector in self.top4Selectors) {
            [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamSelection:)]];
        }
        
        
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
    
    if (self.top4Round.notPassed) {
        // call delegate to react on wish to select a team for top4 round
        int index = [self.top4Selectors indexOfObject:tapGesture.view];
        Top4Selector *teamSelector = [self.top4Selectors objectAtIndex:index];
        [self.delegate selectTeamFor:index + 1 currentSelection:teamSelector.team];
    } 
    else {
        // top 4 round is closed -> show error message
        [self.overviewViewController showError:@"Denna omgång är stängd."];
    }
}

- (void) setTop4Round:(Top4Round *)top4Round {
    _top4Round = top4Round;
    
    [[self.top4Selectors objectAtIndex:0] setTeam:top4Round.top4Tips.firstTeam];
    [[self.top4Selectors objectAtIndex:1] setTeam:top4Round.top4Tips.secondTeam];
    [[self.top4Selectors objectAtIndex:2] setTeam:top4Round.top4Tips.thirdTeam];
    [[self.top4Selectors objectAtIndex:3] setTeam:top4Round.top4Tips.fourthTeam];
    
    if (!top4Round.notPassed) {
        for (Top4Selector *selector in self.top4Selectors) {
            selector.locked = YES;
        }
    }
}

- (void) updatePlace:(int) place withTeam:(Team*) team: (RemoteCallBlock) remoteCallBlock {
    
    // if team is already selected on other place, remove this prediction
    int duplicate = 0;
    if ([self.top4Round.top4Tips.firstTeam isEqual:team] && place != 1) {
        duplicate = 1;
        self.top4Round.top4Tips.firstTeam = nil;
    }
    if ([self.top4Round.top4Tips.secondTeam isEqual:team] && place != 2) {
        duplicate = 2;
        self.top4Round.top4Tips.secondTeam = nil;
    }
    if ([self.top4Round.top4Tips.thirdTeam isEqual:team] && place != 3) {
        duplicate = 3;
        self.top4Round.top4Tips.thirdTeam = nil;
    }
    if ([self.top4Round.top4Tips.fourthTeam isEqual:team] && place != 4) {
        duplicate = 4;
        self.top4Round.top4Tips.fourthTeam = nil;
    }
    if (duplicate > 0) {
        Top4Selector *selectorToClean = [self.top4Selectors objectAtIndex:(duplicate-1)];
        selectorToClean.team = nil;
        [BackendAdapter postPredictionForPlace:duplicate andTeam:[NSNumber numberWithInt:0] :^(RemoteCallResult remoteCallResult) {
            
            if (remoteCallResult == OK) {
                [self saveTeamPrediction:place :team :remoteCallBlock];
            }
            else {
                remoteCallBlock(remoteCallResult);
            }
        }];
    } 
    else {
        [self saveTeamPrediction:place :team :remoteCallBlock];
    }
}

- (void) saveTeamPrediction:(int) place:(Team*) team:(RemoteCallBlock) remoteCallBlock {
    if (place == 1) self.top4Round.top4Tips.firstTeam = team;
    if (place == 2) self.top4Round.top4Tips.secondTeam = team;
    if (place == 3) self.top4Round.top4Tips.thirdTeam = team;
    if (place == 4) self.top4Round.top4Tips.fourthTeam = team;
    
    Top4Selector *selector = [self.top4Selectors objectAtIndex:place - 1];
    selector.team = team;
    
    // send update to server
    [BackendAdapter postPredictionForPlace:place andTeam:team.teamId :remoteCallBlock];
}

@end
