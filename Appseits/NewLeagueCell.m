//
//  NewLeagueCelll.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLeagueCell.h"

@interface NewLeagueCell()
@property (nonatomic, strong) UITextField* textInput;
@end

@implementation NewLeagueCell

@synthesize delegate = _delegate;
@synthesize textInput = _textInput;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textInput = (UITextField*) [self viewWithTag:1];
        self.textInput.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted {
    
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
