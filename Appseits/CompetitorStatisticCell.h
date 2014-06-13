//
//  CompetitorStatisticCell.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitorStatisticCell : UITableViewCell

@property (nonatomic, strong) UIImageView *flag;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *points;

- (void) setOdd:(BOOL) odd;

@end
