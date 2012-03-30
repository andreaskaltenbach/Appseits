//
//  Menu.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColors.h"

@interface Menu()
@property (nonatomic, strong) UIView *resultMenuItem;
@property (nonatomic, strong) UIView *rankingMenuItem;
@property (nonatomic, strong) CAGradientLayer *selectedItemLayer;
@property (nonatomic, strong) CAGradientLayer *unselectedItemLayer;

#define MENU_ITEM_WIDTH 100
#define MARGIN_RIGHT 10

@end
@implementation Menu

@synthesize resultMenuItem = _resultMenuItem;
@synthesize rankingMenuItem = _rankingMenuItem;
@synthesize selectedItemLayer = _selectedItemLayer;
@synthesize unselectedItemLayer = _unselectedItemLayer;

- (void) selectResultTab {
    UILabel *resultText = [self.resultMenuItem.subviews objectAtIndex:0];
    resultText.textColor = [UIColor whiteColor];
    [self.resultMenuItem.layer insertSublayer:self.selectedItemLayer atIndex:0];    
    
    UILabel *rankingText = [self.rankingMenuItem.subviews objectAtIndex:0];
    rankingText.textColor = [UIColor blackColor];
    [self.rankingMenuItem.layer insertSublayer:self.unselectedItemLayer atIndex:0];
    
}

- (void) selectRankingTab {
    UILabel *resultText = [self.resultMenuItem.subviews objectAtIndex:0];
    resultText.textColor = [UIColor blackColor];
    [self.resultMenuItem.layer insertSublayer:self.unselectedItemLayer atIndex:0];    
    
    UILabel *rankingText = [self.rankingMenuItem.subviews objectAtIndex:0];
    rankingText.textColor = [UIColor whiteColor];
    [self.rankingMenuItem.layer insertSublayer:self.selectedItemLayer atIndex:0];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [UIColor menuGrayGradient];
        
        gradient.shadowColor = [UIColor blackColor].CGColor;
        gradient.shadowOpacity = 0.7f;
        gradient.shadowOffset = CGSizeMake(0.0f, 5.0f);
        gradient.shadowRadius = 5.0f;
        [self.layer insertSublayer:gradient atIndex:0];
        
        int width = self.frame.size.width;
        int height = self.frame.size.height;
        
        // create gradient layer for selected menu item
        self.selectedItemLayer = [CAGradientLayer layer];
        self.selectedItemLayer.frame = CGRectMake(0, 0, MENU_ITEM_WIDTH, height);
        self.selectedItemLayer.colors = [UIColor menuGreenGradient];
        
        self.unselectedItemLayer = [CAGradientLayer layer];
        self.unselectedItemLayer.frame = CGRectMake(0, 0, MENU_ITEM_WIDTH, height);
        self.unselectedItemLayer.colors = [UIColor menuGrayGradient];
                
        // create result tab
        self.resultMenuItem = [[UIView alloc] initWithFrame:CGRectMake(width - MARGIN_RIGHT - 2*MENU_ITEM_WIDTH, 0, MENU_ITEM_WIDTH, height)];
        UILabel  *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MENU_ITEM_WIDTH, height)];
        resultLabel.backgroundColor = [UIColor clearColor];
        resultLabel.text = @"Resultat";
        resultLabel.textAlignment = UITextAlignmentCenter;
        [self.resultMenuItem addSubview:resultLabel];
        [self addSubview:self.resultMenuItem];
        [self.resultMenuItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectResultTab)]];
        
        // create ranking tab
        self.rankingMenuItem = [[UIView alloc] initWithFrame:CGRectMake(width - MARGIN_RIGHT - MENU_ITEM_WIDTH, 0, MENU_ITEM_WIDTH, height)];
        UILabel  *rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MENU_ITEM_WIDTH, height)];
        rankingLabel.backgroundColor = [UIColor clearColor];
        rankingLabel.text = @"Tabeller";
        rankingLabel.textAlignment = UITextAlignmentCenter;
        [self.rankingMenuItem addSubview:rankingLabel];
        [self addSubview:self.rankingMenuItem];
        [self.rankingMenuItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRankingTab)]];
        
        [self selectResultTab];
    }
        
    return self;
}

@end
