//
//  MainScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScrollView.h"

#define PUSH_TO_REFRESH_HEIGHT 70
#define SCORE_VIEW_HEIGHT 50

@implementation MainScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code

        self.scrollEnabled = YES;
        self.bounces = NO;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + PUSH_TO_REFRESH_HEIGHT + SCORE_VIEW_HEIGHT);
        
        [self scrollRectToVisible:CGRectMake(0, PUSH_TO_REFRESH_HEIGHT, self.frame.size.width, self.frame.size.height) animated:NO];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
