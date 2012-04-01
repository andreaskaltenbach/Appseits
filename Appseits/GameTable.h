//
//  GameTable.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRound.h"

@interface GameTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TournamentRound *round;

@end
