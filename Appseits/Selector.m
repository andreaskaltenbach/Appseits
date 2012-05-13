//
//  Selector.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Selector.h"

static UIImage *background;

@interface Selector()
@property (nonatomic, strong) UIImageView *image;
@end

@implementation Selector

@synthesize label = _label;
@synthesize flag = _flag;
@synthesize image = _image;

@synthesize selectable = _selectable;

+ (void) initialize {
    background = [UIImage imageNamed:@"predictionSelector"];
}

- (id) init:(UIImage*) image {
    
    self = [super init];
    if (self) {
        [self setBackgroundImage:background forState:UIControlStateNormal];
        
        // setup image
        self.image = [[UIImageView alloc] initWithImage:image];
        self.image.frame = CGRectMake(20, (48 - image.size.height) / 2, image.size.width, image.size.height);
        [self addSubview:self.image];
        
        // setup label
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 50)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:self.label];
        
        //setup flag image
        self.flag = [[UIImageView alloc] initWithFrame:CGRectMake(84, 16, 16, 16)];
        [self addSubview:self.flag];
    }
    return self;
}

@end
