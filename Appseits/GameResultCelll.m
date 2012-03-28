//
//  GameResultCelll.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameResultCelll.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColors.h"


@interface GameResultCelll()
@end

@implementation GameResultCelll

@synthesize game = _game;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [UIColor gameCellGradient];
        [self.layer insertSublayer:gradient atIndex:0];
        
        
    }
    return self;
}

- (void) setGame:(Game *)game {
    [super setGame:game];
}

@end
