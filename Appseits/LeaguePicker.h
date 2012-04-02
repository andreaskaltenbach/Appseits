//
//  LeaguePicker.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@protocol LeaguePickDelegate

@required
- (void) leaguePicked:(League*) league;

@end

@interface LeaguePicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) id<LeaguePickDelegate> leaguePickerDelegate;
@property (nonatomic, strong) League *selectedLeague;

@end
