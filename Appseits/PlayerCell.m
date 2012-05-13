//
//  PlayerCell.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerCell.h"

@interface PlayerCell()
@property (nonatomic, strong) UIImageView *flag;
@property (nonatomic, strong) UILabel *name;
@end

@implementation PlayerCell

@synthesize flag = _flag;
@synthesize name = _name;
@synthesize player = _player;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.flag = (UIImageView*) [self viewWithTag:1];
        self.name = (UILabel*) [self viewWithTag:2];
    }
    return self;
}

- (void) setPlayer:(Player *)player {
    _player = player;
    self.flag.image = player.team.flag;
    self.name.text = player.name;
}

@end
