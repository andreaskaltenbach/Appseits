//
//  GameTable.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"
#import "ScrollTriggeringTableView.h"

@interface GameTable : ScrollTriggeringTableView<UITableViewDataSource>

@property (nonatomic, strong) TournamentRound *round;

@end
