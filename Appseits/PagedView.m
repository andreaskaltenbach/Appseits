//
//  PagedScrollView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PagedView.h"

@interface PagedView()

@property int pageIndex;

@end

@implementation PagedView

@synthesize pageIndex = _pageIndex;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self layoutChildren:self.frame];
        
        UIView *first = 
        [self.subviews objectAtIndex:0];
        first.backgroundColor = [UIColor yellowColor];
        
        first = 
        [self.subviews objectAtIndex:1];
        first.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void) layoutChildren:(CGRect) frame {
    int subviews = [self.subviews count];
    self.contentSize = CGSizeMake(frame.size.width * subviews, frame.size.height);
    int xOffset = 0;
    for (UIView *subview in self.subviews) {
        subview.frame = CGRectMake(xOffset, 0, frame.size.width, frame.size.height);
        xOffset+= frame.size.width;
        NSLog(@"Subview: %f, %f, %f , %f", subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height
              );
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
