//
//  RankingCell.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ranking.h"

@interface RankingCell : UITableViewCell

@property (nonatomic, strong) Ranking *ranking;

- (void) odd;
- (void) even;

@end
