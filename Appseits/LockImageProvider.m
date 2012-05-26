//
//  LockImageProvider.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LockImageProvider.h"
#import "TournamentRound.h"

@implementation LockImageProvider

static UIImage *lockClosedInset;
static UIImage *lockOpenInset;
static UIImage *lockGreenOpen;
static UIImage *lockGrayOpen;
static UIImage *lockGreenClosed;
static UIImage *lockUnfinished;
static UIImage *lockUnfinishedInset;

+ (void) initialize {
    lockClosedInset = [UIImage imageNamed:@"lockClosedInset"];
    lockOpenInset = [UIImage imageNamed:@"lockOpenInset"];
    lockGreenOpen = [UIImage imageNamed:@"lockGreenOpen"];
    lockGrayOpen = [UIImage imageNamed:@"lockGrayOpen"];
    lockGreenClosed = [UIImage imageNamed:@"lockGreenClosed"];
    lockUnfinished = [UIImage imageNamed:@"lockUnfinished"];
    lockUnfinishedInset = [UIImage imageNamed:@"lockUnfinishedInset"];
}

+ (UIImage*) imageForTournamentRound:(TournamentRound*) tournamentRound:(BOOL) selected  {
    if (selected) {
        return [self selectedImage:tournamentRound];
    }
    else {
        return [self deselectedImage:tournamentRound];
    }
}

+ (UIImage*) selectedImage:(TournamentRound*) round {
    if (round.open) {
        if (round.readyToBet && !round.allPredictionsDone) {
            return lockUnfinishedInset;
        }
        else {
            return lockOpenInset;
        }
    }
    else {
        return lockClosedInset;
    }
}

+ (UIImage*) deselectedImage:(TournamentRound*) round {
    if (round.open) {
        if (round.allPredictionsDone) {
            return lockGreenOpen;
        }
        else {
            if (round.readyToBet) {
                return lockUnfinished;
           
            } 
            else {
                return lockGrayOpen;
            }
        }
    }
    else {
        return lockGreenClosed;
    }
}

@end
