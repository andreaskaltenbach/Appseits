//
//  LeagueSelector.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@protocol LeagueSelectionDelegate

- (void) leagueSelected:(League*) league;

@end

@interface LeagueSelector : UIView<UITableViewDataSource, UITableViewDelegate>
@property id<LeagueSelectionDelegate> leagueSelectionDelegate; 
@end
