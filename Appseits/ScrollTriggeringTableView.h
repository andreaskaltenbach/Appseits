//
//  ScrollTriggeringTableView.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTriggeringTableView : UITableView<UITableViewDelegate>

@property id<UIScrollViewDelegate> scrollDelegate;



@end
