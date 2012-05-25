//
//  TeamSelectDelegate.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TeamSelectDelegate
- (void) selectTeamFor:(int) place currentSelection: (Team*) team;
@end
