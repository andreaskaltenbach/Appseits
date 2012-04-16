//
//  LeaguePickerDataSource.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaguePickerDataSourceDelegate.h"
#import "BackendAdapter.h"

@implementation LeaguePickerDataSourceDelegate

static LeaguePickerDataSourceDelegate *singleton;

+ (LeaguePickerDataSourceDelegate*) instance {
    return singleton;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        singleton = [[LeaguePickerDataSourceDelegate alloc] init];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [BackendAdapter.leagues count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        return @"Alla ligor";
    }
    else {
        League *league = [BackendAdapter.leagues objectAtIndex:row - 1];
        return league.name;
    }
}


@end
