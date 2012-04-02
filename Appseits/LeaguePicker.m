//
//  LeaguePicker.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaguePicker.h"
#import "League.h"

@interface LeaguePicker()

@property (nonatomic, strong) NSArray *leagues;

@end

@implementation LeaguePicker

@synthesize leagues = _leagues;
@synthesize selectedLeague = _selectedLeague;
@synthesize leaguePickerDelegate = _leaguePickerDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [League getAllLeagues:^(NSArray *leagues) {
            self.leagues = leagues;
        } :^(NSString *errorMessage) {
            NSLog(@"Failed to fetch leagues");
        } ];
    }
    return self;
}

- (void) setLeagues:(NSArray *)leagues {
    _leagues = leagues;
    [self reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.leagues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    League *league = [self.leagues objectAtIndex:row];
    return league.name;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"League selected");
    self.selectedLeague = [self.leagues objectAtIndex:row];
    [self.leaguePickerDelegate leaguePicked:self.selectedLeague];
}

@end
