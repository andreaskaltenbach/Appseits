//
//  ScrollTriggeringTableView.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollDelegate <NSObject>

- (void) scroll:(int) offset;
- (void) snapBack;

@end

@interface ScrollTriggeringTableView : UITableView<UITableViewDelegate>

@property (unsafe_unretained) id<ScrollDelegate> scrollDelegate;



@end
