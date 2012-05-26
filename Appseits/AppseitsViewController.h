//
//  AppseitsViewController.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppseitsViewController : UIViewController

typedef void(^PromptConfirmedBlock)();

- (void) showInfo:(NSString*) message;

- (void) showConfirmation:(NSString*) message;

- (void) showError:(NSString*) message;

- (void) showPrompt:(NSString*) message: (NSString*) confirmMessage: (NSString*) abortMessage: (PromptConfirmedBlock) onConfirm;

- (void) hideNotification;

@end
