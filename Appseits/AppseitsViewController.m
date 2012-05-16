//
//  AppseitsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsViewController.h"

#define OFFSET 10

static UIFont *messageFont;

@interface AppseitsViewController ()
@property (nonatomic, strong) UIView *notificationBox;
@property (nonatomic, strong) UILabel *notificationLabel;
@end

@implementation AppseitsViewController
@synthesize notificationLabel = _notificationLabel;
@synthesize notificationBox = _notificationBox;

+ (void) initialize {
    messageFont = [UIFont systemFontOfSize:14];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (UIView*) notificationBox {
    if (_notificationBox) return _notificationBox;
    
    _notificationBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _notificationBox.hidden = YES;

    [self.view addSubview:_notificationBox];
    
    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    self.notificationLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.notificationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.notificationLabel.backgroundColor = [UIColor clearColor];
    self.notificationLabel.numberOfLines = 0;
    self.notificationLabel.font = messageFont;
    [_notificationBox addSubview:self.notificationLabel];
    
    return _notificationBox;
}

- (void) layoutNotificationBox:(NSString*) message {
    float messageWidth = self.view.frame.size.width - 2*OFFSET;
    CGSize messageSize = [message sizeWithFont:messageFont constrainedToSize:CGSizeMake(messageWidth, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.notificationBox.frame = CGRectMake(0, -(messageSize.height + 2*OFFSET), self.view.frame.size.width, messageSize.height+ 2*OFFSET);
    self.notificationLabel.text = message;
    self.notificationBox.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{

    }];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // animate fly-in
        self.notificationBox.frame = CGRectMake(0, 0, self.view.frame.size.width, messageSize.height+ 2*OFFSET);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.notificationBox.frame = CGRectMake(0, -(messageSize.height + 2*OFFSET), self.view.frame.size.width, messageSize.height+ 2*OFFSET);
            // animate fly-out after 5 seconds
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void) showInfo:(NSString*) message {
    
    self.notificationBox.backgroundColor = [UIColor yellowColor];
    [self layoutNotificationBox:message];
}

- (void) showError:(NSString*) message {
    self.notificationBox.backgroundColor = [UIColor redColor];
    [self layoutNotificationBox:message];
}

- (void) hideMessage {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notificationBox.frame = CGRectMake(0, -(self.notificationBox.frame.size.height + 2*OFFSET), self.view.frame.size.width, self.notificationBox.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


@end
