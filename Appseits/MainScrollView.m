//
//  MainScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScrollView.h"

#define SCORE_VIEW_HEIGHT 50

@implementation MainScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code

        self.scrollEnabled = YES;
        self.bounces = YES;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + SCORE_VIEW_HEIGHT);
        
        [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:NO];
        
    }
    return self;
}

@end
