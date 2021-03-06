//
//  TeamTableViewControllerViewController.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "OverviewViewController.h"

@interface TeamViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, weak) OverviewViewController *overviewController;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@end
