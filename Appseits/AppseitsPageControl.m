//
//  AppseitsPageControl.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-04-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsPageControl.h"

static UIImage *activeImage;
static UIImage *inactiveImage;

@interface AppseitsPageControl()
@property (nonatomic, strong) UIImage* activeImage;
@property (nonatomic, strong) UIImage* inactiveImage;
@end

@implementation AppseitsPageControl

@synthesize activeImage = _activeImage;
@synthesize inactiveImage = _inactiveImage;

+(void) initialize {
    activeImage = [UIImage imageNamed:@"pageControl_active.png"];
    inactiveImage = [UIImage imageNamed:@"pageControl_inactive.png"];
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

@end
