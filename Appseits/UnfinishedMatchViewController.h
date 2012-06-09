//
//  UnfinishedMatchViewController.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Match.h"
#import "AppseitsViewController.h"

@interface UnfinishedMatchViewController : AppseitsViewController<CPTPieChartDataSource, CPTPieChartDelegate>

@property (nonatomic, strong) Match* match;

@end
