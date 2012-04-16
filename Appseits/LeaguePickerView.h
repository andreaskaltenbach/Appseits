//
//  LeaguePickerView.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@protocol LeagueDelegate

- (void) leagueChanged:(League*) league;

@end

@interface LeaguePickerView : UIView<UIPickerViewDelegate>
@property id<LeagueDelegate> leagueDelegate;

- (void) show;

@end
