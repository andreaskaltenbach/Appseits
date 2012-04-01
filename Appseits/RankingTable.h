//
//  RankingTable.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *rankings;

@end
