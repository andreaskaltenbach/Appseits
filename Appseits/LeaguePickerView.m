//
//  LeaguePickerView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaguePickerView.h"
#import "League.h"
#import "Constants.h"

@interface LeaguePickerView() 
@property (nonatomic, strong) UIPickerView *leaguePicker;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *submitButton;
@property (nonatomic, strong) NSArray *leagues;
@property int selectedLeagueIndex;
@end

@implementation LeaguePickerView
@synthesize leaguePicker = _leaguePicker;
@synthesize cancelButton = _cancelButton;
@synthesize submitButton = _submitButton;
@synthesize leagues = _leagues;
@synthesize selectedLeagueIndex = selectedLeagueIndex;
@synthesize leagueDelegate = _leagueDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.leaguePicker = (UIPickerView*) [self viewWithTag:1];
        self.leaguePicker.dataSource = self;
        self.leaguePicker.delegate = self;
        
        UIToolbar *toolbar = (UIToolbar*) [self.subviews objectAtIndex:0];
        self.cancelButton = [toolbar.items objectAtIndex:0];
        self.cancelButton.action = @selector(cancel);
        self.submitButton = [toolbar.items objectAtIndex:2];
        self.submitButton.action = @selector(submit);

        // fetch the previously selected league
        [self selectLeagueItem];
    }
    return self;
}

- (void) selectLeagueItem {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *leagueId = [userDefaults objectForKey:LEAGUE_ID_KEY];
    
    [League getAllLeagues:^(NSArray *leagues) {
        self.leagues = leagues;
        [self.leaguePicker reloadAllComponents];
        int index = 0;
        if (leagueId) {
            for (League *league in self.leagues) {
                if (league.id == leagueId) {
                    [self.leaguePicker selectRow:index + 1 inComponent:0 animated:NO];
                }
                index++;
            }
        }
        
    } :^(NSString *errorMessage) {
        NSLog(@"Failed to fetch leagues");
    } ];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.leagues count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        return @"Alla ligor";
    }
    else {
        League *league = [self.leagues objectAtIndex:row - 1];
        return league.name;
    }
}

- (void) show {
    [UIView beginAnimations:nil context:NULL];
    CGRect pickerFrame = self.frame;
    pickerFrame.origin.y = pickerFrame.origin.y - pickerFrame.size.height;
    self.frame = pickerFrame; 
    
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}

- (void) hide {
    [UIView beginAnimations:nil context:NULL];
    CGRect pickerFrame = self.frame;
    pickerFrame.origin.y = pickerFrame.origin.y + pickerFrame.size.height;
    self.frame = pickerFrame; 
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
}

- (void) submit {
    [self hide];
    // store selection in user defaults
    self.selectedLeagueIndex = [self.leaguePicker selectedRowInComponent:0];
    
    if (self.selectedLeagueIndex == 0) {
        [League setSelectedLeague:nil];
        [self.leagueDelegate leagueChanged:nil];        
    }
    else {
        // store the selected league
        League *selectedLeague = [self.leagues objectAtIndex:self.selectedLeagueIndex -1];
        [League setSelectedLeague:selectedLeague];
        [self.leagueDelegate leagueChanged:selectedLeague];
    }
}

- (void) cancel {
    [self hide];
    if (self.selectedLeagueIndex != [self.leaguePicker selectedRowInComponent:0]) {
        [self.leaguePicker selectRow:self.selectedLeagueIndex inComponent:0 animated:NO];
    }
}


@end
