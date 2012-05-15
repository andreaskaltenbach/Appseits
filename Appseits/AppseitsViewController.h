//
//  AppseitsViewController.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppseitsViewController : UIViewController

- (void) showInfo:(NSString*) message;

- (void) showError:(NSString*) message;

- (void) hideMessage;

@end
