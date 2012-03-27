//
//  MatchCellCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePredictionCell.h"
#import "Game.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColors.h"

@interface GamePredictionCell()

@property (nonatomic, strong) UIImageView *firstTeamImage;
@property (nonatomic, strong) UIImageView *secondTeamImage;
@property (nonatomic, strong) UILabel *firstTeamName;
@property (nonatomic, strong) UILabel *secondTeamName;
@property (nonatomic, strong) UITextField *firstTeamGoalsBet;
@property (nonatomic, strong) UITextField *secondTeamGoalsBet;
@property (nonatomic, strong) UILabel *matchResultLabel;
@property (nonatomic, strong) UILabel *pointsLabel;

@end

@implementation GamePredictionCell

@synthesize game = _game;
@synthesize firstTeamImage = _firstTeamImage;
@synthesize secondTeamImage = _secondTeamImage;
@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;
@synthesize firstTeamGoalsBet = _firstTeamGoalsBet;
@synthesize secondTeamGoalsBet = _secondTeamGoalsBet;
@synthesize matchResultLabel = _matchResultLabel;
@synthesize pointsLabel = _pointsLabel;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [UIColor gameCellGradient];
        [self.layer insertSublayer:gradient atIndex:0];
        
        self.firstTeamName = (UILabel*) [self viewWithTag:20];
        self.secondTeamName = (UILabel*) [self viewWithTag:21];
        
        
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyPressed:) name: object:self.firstTeamGoalsBet];
    }
    return self;
}

- (void) keyPressed:(NSNotification*) notification {
    NSLog(@"%@", notification.userInfo);
    NSLog(@"Key pressed!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setGame:(Game *)game {
    _game = game;
    
    self.firstTeamName.text = game.firstTeamName;
    self.secondTeamName.text = game.secondTeamName;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%i", row];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}// return NO to disallow editing.

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"Editing!");
    
}// became first responder

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end


- (void)textFieldDidEndEditing:(UITextField *)textField {
        NSLog(@"Edited!");
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}// return NO to not change text

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return NO;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
};              // called when 'return' key pressed. return NO to ignore.


@end
