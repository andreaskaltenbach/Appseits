//
//  ScrollTriggeringTableView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollTriggeringTableView.h"

@implementation ScrollTriggeringTableView

@synthesize scrollDelegate = _scrollDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // inform the scroll delegate that a scroll happened
    [self.scrollDelegate scrollViewDidScroll:scrollView];
}

@end
