//
//  NewLeagueCelll.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLeagueCell.h"

static UIImage *buttonImage;

@interface NewLeagueCell()
@property (nonatomic, strong) UITextField* textInput;
@property (nonatomic, strong) UIButton* okButton;
@property (nonatomic, strong) UIButton* leagueButton;
@end

@implementation NewLeagueCell

@synthesize delegate = _delegate;
@synthesize textInput = _textInput;
@synthesize leagueButton = _lLeagueButton;
@synthesize okButton = _okButton;

+ (void) initialize {
    buttonImage = [[UIImage imageNamed:@"leagueSelectButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.textInput = (UITextField*) [self viewWithTag:1];
        self.textInput.delegate = self;
        
        self.okButton = (UIButton*) [self viewWithTag:2];
        [self.okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
        [self.okButton setTitle:@"OK" forState:UIControlStateApplication];
        [self.okButton setTitle:@"OK" forState:UIControlStateHighlighted];
        [self.okButton setTitle:@"OK" forState:UIControlStateSelected];
        
        
        self.leagueButton = (UIButton*) [self viewWithTag:3];
        [self.leagueButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.leagueButton setTitle:@"+ SKAPA EN NY LIGA" forState:UIControlStateNormal];
        [self.leagueButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInput)]];
    }
    return self;
}

- (void) showInput {
    [UIView animateWithDuration:0.3 animations:^{
        self.leagueButton.alpha = 0;
        self.okButton.alpha = 1;
        self.textInput.alpha = 1;
    }];
    
    
    
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
