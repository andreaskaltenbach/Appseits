//
//  LightBlueGradient.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LightBlueGradient.h"
#import "UIColor+AppColors.h"

@implementation LightBlueGradient

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.colors = [UIColor lightBlueGradient];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
