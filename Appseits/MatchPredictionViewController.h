//
//  MatchPredictionViewController.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
#import "AppseitsViewController.h"
#import "OverviewViewController.h"

@interface MatchPredictionViewController : AppseitsViewController

@property (nonatomic, strong) Match* match;
@property (nonatomic, weak) OverviewViewController *overviewViewController;

@end
