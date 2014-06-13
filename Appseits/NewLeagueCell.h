//
//  NewLeagueCelll.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewLeagueDelegate

- (void) createNewLeague:(NSString*) leagueName;

@end

@interface NewLeagueCell : UITableViewCell<UITextFieldDelegate>

@property id<NewLeagueDelegate> delegate;

@end
