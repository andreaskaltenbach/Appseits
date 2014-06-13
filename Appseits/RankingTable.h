//
//  RankingTable.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTriggeringTableView.h"
#import "OverviewViewController.h"

@interface RankingTable : ScrollTriggeringTableView<UITableViewDataSource>

@property (nonatomic, weak) OverviewViewController *overviewViewController;

- (void) refreshRankings;

- (void) scrollToMyself;

@end
