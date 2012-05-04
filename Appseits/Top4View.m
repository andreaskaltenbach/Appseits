//
//  Top4View.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4View.h"
#import "UIColor+AppColors.h"
#import "Top4Selector.h"

#define Y_OFFSET 10
#define MARGIN 60

@interface Top4View()
@property (nonatomic, strong) NSArray *top4Selectors;
@end

@implementation Top4View

@synthesize top4Selectors = _top4Selectors;
@synthesize top4Tips = _top4Tips;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.backgroundColor = [UIColor squareBackground];
    if (self) {
        
        // add cup icons
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first"]];
        imageView.frame = CGRectMake(10, Y_OFFSET, 45, 45);
        [self addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"second"]];
        imageView.frame = CGRectMake(10, Y_OFFSET + MARGIN, 45, 45);
        [self addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"third"]];
        imageView.frame = CGRectMake(10, Y_OFFSET + 2*MARGIN, 45, 45);
        [self addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fourth"]];
        imageView.frame = CGRectMake(10, Y_OFFSET + 3*MARGIN, 45, 45);
        [self addSubview:imageView];
        
        self.top4Selectors = [NSArray arrayWithObjects:
                              [Top4Selector selector], [Top4Selector selector], 
                              [Top4Selector selector], [Top4Selector selector], nil];
        
        int yOffset = Y_OFFSET;
        for (Top4Selector *selector in self.top4Selectors) {
            selector.frame = CGRectMake(70, yOffset, 233, 50);    
            [self addSubview:selector];
            
            yOffset+= MARGIN;
        }
    }
    return self;
}


- (void) setTop4Tips:(Top4Tips *)top4Tips {
    
    
    
    
}



@end
