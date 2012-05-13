//
//  PlayerViewController.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewViewController.h"
#import "Team.h"

@interface PlayerViewController : UIViewController
@property (nonatomic, strong) OverviewViewController *overviewViewController;

@property (nonatomic, strong) Team *team;
@end
