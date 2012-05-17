//
//  RoundSelector.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"

@interface RoundSelector : UIView
@property (nonatomic, strong) id<TournamentRoundSelectDelegate> roundSelectDelegate;
@property (nonatomic, strong) NSArray* tournamentRounds;

@end
