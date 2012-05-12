//
//  TeamCell.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeamCell.h"
#import "BackendAdapter.h"

@interface TeamCell()
@property (nonatomic, strong) UIImageView *flag;
@property (nonatomic, strong) UILabel *name;
@end

@implementation TeamCell
@synthesize flag = _flag;
@synthesize name = _name;
@synthesize team = _team;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.flag = (UIImageView*) [self viewWithTag:1];
        self.name = (UILabel*) [self viewWithTag:2];
    }
    return self;
}

- (void) setTeam:(Team *)team {
    _team = team;
    self.flag.image = team.flag;
    self.name.text = team.name;
}

@end
