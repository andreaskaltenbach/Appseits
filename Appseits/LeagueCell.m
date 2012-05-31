//
//  LeagueCell.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeagueCell.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>

@interface  LeagueCell()
@property (nonatomic, strong) UIView* selectedView;
@end

@implementation LeagueCell

@synthesize selectedView = _selectedView;
@synthesize  leagueName = _leagueName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.leagueName.font = [UIFont systemFontOfSize:14];
        self.leagueName.textColor = [UIColor whiteColor];
        
        self.selectedView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedView.backgroundColor = [UIColor menuSelectedBackground];
        self.selectedView.hidden = YES;
        [self addSubview:self.selectedView];
        [self sendSubviewToBack:self.selectedView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedView.hidden = !selected;
}

- (void) setHighlighted:(BOOL)highlighted {
    
}

- (UILabel*) leagueName {
    if (_leagueName) return _leagueName;
    
    _leagueName = (UILabel*) [self viewWithTag:1];
    return _leagueName;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
