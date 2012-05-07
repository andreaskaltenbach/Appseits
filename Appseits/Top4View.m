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

#define Y_OFFSET 5
#define MARGIN 60

@interface Top4View()
@property (nonatomic, strong) NSArray *top4Selectors;
@end

@implementation Top4View

@synthesize top4Selectors = _top4Selectors;
@synthesize top4Tips = _top4Tips;
@synthesize delegate = _delegate;

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
            
            [selector addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamSelection:)]];
            
            yOffset+= MARGIN;
        }
    }
    return self;
}

- (void)teamSelection:(UITapGestureRecognizer *)tapGesture {
    // call delegate to react on wish to select a team for top4 round
    int index = [self.top4Selectors indexOfObject:tapGesture.view];
    Top4Selector *teamSelector = [self.top4Selectors objectAtIndex:index];
    [self.delegate selectTeamFor:index + 1 currentSelection:teamSelector.team];
}

- (void) setTop4Tips:(Top4Tips *)top4Tips {
    
    [[self.top4Selectors objectAtIndex:0] setTeam:top4Tips.firstTeam];
    [[self.top4Selectors objectAtIndex:1] setTeam:top4Tips.secondTeam];
    [[self.top4Selectors objectAtIndex:2] setTeam:top4Tips.thirdTeam];
    [[self.top4Selectors objectAtIndex:3] setTeam:top4Tips.fourthTeam];
}



@end
