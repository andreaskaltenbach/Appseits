//
//  Selector.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Selector.h"

static UIImage *background;

@implementation Selector

@synthesize label = _label;
@synthesize flag = _flag;

+ (void) initialize {
    background = [UIImage imageNamed:@"top4Selector"];
}

- (void) initialize {
    [self setBackgroundImage:background forState:UIControlStateNormal];
    
    // setup label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont boldSystemFontOfSize:22];
    [self addSubview:self.label];
    
    //setup flag image
    self.flag = [[UIImageView alloc] initWithFrame:CGRectMake(17, 16, 16, 16)];
    [self addSubview:self.flag];
}




@end
