//
//  CompetitorStatisticsViewController.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppseitsViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "Ranking.h"

@interface CompetitorStatisticsViewController : AppseitsViewController<UITableViewDataSource, UITableViewDelegate, CPTPieChartDataSource, CPTPieChartDelegate>

@property (nonatomic, strong) Ranking* ranking;

@end
