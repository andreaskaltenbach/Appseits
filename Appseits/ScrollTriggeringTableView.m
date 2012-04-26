//
//  ScrollTriggeringTableView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollTriggeringTableView.h"

@interface ScrollTriggeringTableView()

@property int lastYOffset;
@property int realDeviance;
@property BOOL tracking;
@property BOOL scrollDelegated;

@end

@implementation ScrollTriggeringTableView
@synthesize lastYOffset = _lastYOffset;
@synthesize tracking = _tracking;
@synthesize realDeviance = _realDeviance;
@synthesize scrollDelegated = _scrollDelegated;

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

    
    
    if ((self.tracking && scrollView.contentOffset.y < 0) || (self.scrollDelegated && self.realDeviance < 0)) {
        // bouncing upwards
        
        self.scrollDelegated = YES;

        NSLog(@"Bounce %f", scrollView.contentOffset.y);

        
        // inform the scroll delegate that a bounce scroll happens
        [self.scrollDelegate scroll:scrollView.contentOffset.y - self.lastYOffset];
        
        self.realDeviance += scrollView.contentOffset.y;
        NSLog(@"real deviance %i", self.realDeviance);
        
        
        self.contentOffset = CGPointZero;


    }
    
    self.lastYOffset = scrollView.contentOffset.y;
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"BEGIN");
    self.tracking = YES;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
        NSLog(@"END");
    self.tracking = NO;
    self.scrollDelegated = NO;

    [self.scrollDelegate snapBack];
}

@end
