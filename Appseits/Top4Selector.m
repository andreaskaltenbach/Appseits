//
//  Top4Selector.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4Selector.h"

static UIImage *background;

@interface Top4Selector()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *flag;

@end

@implementation Top4Selector
@synthesize label = _label;
@synthesize flag = _flag;

+ (void) initialize {
    background = [UIImage imageNamed:@"top4Selector"];
}

+ (id) selector {
    Top4Selector *selector = [[Top4Selector alloc] init];
    [selector setBackgroundImage:background forState:UIControlStateNormal];
    
    // setup label
    selector.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
    selector.label.backgroundColor = [UIColor clearColor];
    selector.label.text = @"---";
    selector.label.font = [UIFont boldSystemFontOfSize:22];
    [selector addSubview:selector.label];
    
    //setup flag image
    selector.flag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [selector addSubview:selector.flag];
    
    return selector;
}


@end
