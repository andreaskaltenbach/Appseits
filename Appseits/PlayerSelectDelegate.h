//
//  PlayerSelectDelegate.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerSelectDelegate
- (void) selectPlayerFor:(int) place currentSelection: (Player*) player;
@end
