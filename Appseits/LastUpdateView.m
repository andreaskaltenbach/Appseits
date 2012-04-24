//
//  LastUpdateView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LastUpdateView.h"
#import "UIColor+AppColors.h"

static UIImage *clockImage;

@interface LastUpdateView()



@end

@implementation LastUpdateView

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
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        self.label.text = @"Senast uppdaterad: 2012-04-20";
        

    }
    return self;
}


@end
