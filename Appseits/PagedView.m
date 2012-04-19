//
//  PagedScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PagedView.h"
#import "AppseitsPageControl.h"

@interface PagedView()
@property (nonatomic, strong) AppseitsPageControl *pageControl;

@property int pageIndex;

@end

@implementation PagedView

@synthesize pageIndex = _pageIndex;
@synthesize pageControl = _pageControl;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self layoutChildren:self.frame];
        
        int height = self.frame.size.height;
        
        self.pageControl = [[AppseitsPageControl alloc] initWithFrame:CGRectMake(height - 30, 0, self.frame.size.width, 30)];
        self.pageControl.numberOfPages = [self.subviews count];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

- (void) layoutChildren:(CGRect) frame {
    int subviews = [self.subviews count];
    self.contentSize = CGSizeMake(frame.size.width * subviews, frame.size.height);
    int xOffset = 0;
    for (UIView *subview in self.subviews) {
        
        if (subview != self.pageControl) {
        
        subview.frame = CGRectMake(xOffset, 0, frame.size.width, frame.size.height);
        xOffset+= frame.size.width;
                }
    }
}

- (void) setFrame:(CGRect)frame {
    
    [self layoutChildren:frame];
    
    [super setFrame:frame];
    
    [self scrollRectToVisible:CGRectMake(self.pageIndex * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
}

- (void) selectPage:(int) index {
    self.pageIndex = index;
    [self scrollRectToVisible:CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
}

@end
