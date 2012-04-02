//
//  MenuDependendScrollView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuDependendScrollView.h"

typedef enum {
    MATCHES,
    RANKING
} ActiveView;

@interface MenuDependendScrollView()
@property ActiveView activeView;

@end

@implementation MenuDependendScrollView

@synthesize activeView = _activeView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)setFrame:(CGRect)frame {
    NSLog(@"Changed frame");
    
    self.contentSize = CGSizeMake(2*frame.size.width, frame.size.height);
    

    float width = frame.size.width;
    int xOffset = 0;
    
    
    for (UIView *subView in self.subviews) {
        CGRect subFrame = subView.frame;
        subFrame.size.width = width;
        subFrame.origin.x = xOffset;
        subView.frame = subFrame;
       
        xOffset+= width;
    }
    
    switch (self.activeView) {
        case MATCHES:
            [self setContentOffset:CGPointMake(0, 0)];
            break;
        case RANKING:
            [self setContentOffset:CGPointMake(width, 0)];
        default:
            break;
    }
    
    [super setFrame:frame];
}


- (void) scrollToRankings {
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    self.activeView = RANKING;
}

- (void) scrollToMatches {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
    self.activeView = MATCHES;
}

@end
