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
#import "BackendAdapter.h"
#import "LeaguePickerDataSourceDelegate.h"

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
        self.leaguePicker.dataSource = [LeaguePickerDataSourceDelegate instance];
        self.leaguePicker.delegate = [LeaguePickerDataSourceDelegate instance];
        
        UIToolbar *toolbar = (UIToolbar*) [self.subviews objectAtIndex:0];
        self.cancelButton = [toolbar.items objectAtIndex:0];
        self.cancelButton.action = @selector(cancel);
        self.submitButton = [toolbar.items objectAtIndex:2];
        self.submitButton.action = @selector(submit);

        // initialize leagues
        self.leagues = [BackendAdapter leagues];
        [self selectLeagueItem];
    }
    return self;
}

- (void) selectLeagueItem {
    League *currentLeague = [BackendAdapter currentLeague];
    
    if (!currentLeague) {
        [self.leaguePicker selectRow:0 inComponent:0 animated:NO];
    }
    else {
        int leagueIndex = [[BackendAdapter leagues] indexOfObject:currentLeague];
        [self.leaguePicker selectRow:leagueIndex + 1 inComponent:0 animated:NO];
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

    self.selectedLeagueIndex = [self.leaguePicker selectedRowInComponent:0];
    
    League *league;
    if (self.selectedLeagueIndex != 0) {
        // an explicit league was selected 
        league = [[BackendAdapter leagues] objectAtIndex:self.selectedLeagueIndex - 1];
    }
    
    [BackendAdapter setCurrentLeague:league :^(RemoteCallResult error) {
        [self.leagueDelegate leagueChanged:league];
    }];
}

- (void) cancel {
    [self hide];
    if (self.selectedLeagueIndex != [self.leaguePicker selectedRowInComponent:0]) {
        [self.leaguePicker selectRow:self.selectedLeagueIndex inComponent:0 animated:NO];
    }
}


@end
