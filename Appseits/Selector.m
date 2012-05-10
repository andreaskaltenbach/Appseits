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

+ (id) selector {
    Selector *selector = [[Selector alloc] init];
    [selector setBackgroundImage:background forState:UIControlStateNormal];
    
    // setup label
    selector.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
    selector.label.backgroundColor = [UIColor clearColor];
    selector.label.font = [UIFont boldSystemFontOfSize:22];
    [selector addSubview:selector.label];
    
    //setup flag image
    selector.flag = [[UIImageView alloc] initWithFrame:CGRectMake(17, 16, 16, 16)];
    [selector addSubview:selector.flag];
    
    return selector;
}




@end
