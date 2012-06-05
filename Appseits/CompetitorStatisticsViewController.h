//
//  CompetitorStatisticsViewController.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppseitsViewController.h"

@interface CompetitorStatisticsViewController : AppseitsViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* userId;

@end
