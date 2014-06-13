//
//  YellowBar.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YellowBar.h"
#import "UIColor+AppColors.h"

static UIImage *clockImage;

@implementation YellowBar

@synthesize label = _label;

+ (void) initialize {
    clockImage = [UIImage imageNamed:@"11-clock.png"];
    
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.colors = [UIColor lastUpdatedGradient];
        
        UIImageView *clockImageView = [[UIImageView alloc] initWithImage:clockImage];
        clockImageView.frame = CGRectMake(6, 6, 16, 16);
        [self addSubview:clockImageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 290, self.frame.size.height)];
        self.label.textColor = [UIColor lastUpdatedTextColor];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
    }
    return self;
}


@end
