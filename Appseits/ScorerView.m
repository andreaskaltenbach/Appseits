//
//  ScorerView.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScorerView.h"
#import "UIColor+AppColors.h"
#import "ScorerSelector.h"
#import "Top4View.h"

@interface ScorerView()
@property (nonatomic, strong) NSArray *scorerSelectors;
@end

@implementation ScorerView

@synthesize scorerTips = _scorerTips;
@synthesize delegate = _delegate;
@synthesize scorerSelectors = _scorerSelectors;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    
    if (self) {
        
        self.backgroundColor = [UIColor blackBackground];
        
        self.scorerSelectors = [NSArray arrayWithObjects: 
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              [[ScorerSelector alloc] init:[UIImage imageNamed:@"scorer"]],
                              nil];
        
        int yOffset = Y_OFFSET;
        for (ScorerSelector *selector in self.scorerSelectors) {
            selector.frame = CGRectMake(5, yOffset, 310, 50);    
            [self addSubview:selector];
            
            [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamSelection:)]];
            
            yOffset+= MARGIN;
        }
    }
    return self;
}

@end
