//
//  MenuDependendScrollView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuDependendScrollView.h"

@implementation MenuDependendScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.contentSize = CGSizeMake(2*rect.size.width, rect.size.height);
    [super drawRect:rect];	
}

- (void) scrollToRankings {
    [self setContentOffset:CGPointMake(320, 0) animated:YES];
}

- (void) scrollToMatches {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
