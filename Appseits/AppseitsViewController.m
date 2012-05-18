//
//  AppseitsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsViewController.h"

#define OFFSET 10

#define BUTTON_ROW_HEIGHT 40

static UIFont *messageFont;

@interface AppseitsViewController ()
@property (nonatomic, strong) UIView *notificationBox;
@property (nonatomic, strong) UILabel *notificationLabel;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *abortButton;
@end

@implementation AppseitsViewController
@synthesize notificationLabel = _notificationLabel;
@synthesize notificationBox = _notificationBox;
@synthesize confirmButton = _confirmButton;
@synthesize abortButton = _abortButton;
@synthesize buttonView = _buttonView;

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
    
    // setup notification box
    _notificationBox = [[UIView alloc] init];
    _notificationBox.hidden = YES;
    _notificationBox.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_notificationBox];
    
    // setup label
    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 30)];
    self.notificationLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.notificationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.notificationLabel.backgroundColor = [UIColor clearColor];
    self.notificationLabel.numberOfLines = 0;
    self.notificationLabel.font = messageFont;
    [_notificationBox addSubview:self.notificationLabel];
    
    // setup button view
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 180, 40)];
    self.buttonView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.buttonView.backgroundColor = [UIColor greenColor];
    self.buttonView.hidden = YES;
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buttonView addSubview:self.confirmButton];
    
    self.abortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buttonView addSubview:self.abortButton];
    
    [_notificationBox addSubview:self.buttonView];
    
    return _notificationBox;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutNotificationBox];
}

- (void) layoutNotificationBox {
    
    float totalWidth = self.view.frame.size.width;
    
    // calculate dimensions for the text
    CGSize messageSize = [self.notificationLabel.text sizeWithFont:messageFont constrainedToSize:CGSizeMake( totalWidth - 2*OFFSET, 9999) lineBreakMode:UILineBreakModeWordWrap];
        
    // set dimensions of the notification box
    float notificationBoxHeight = OFFSET + messageSize.height + OFFSET;
    
    // make box bigger, if buttons are visible
    if (!self.buttonView.hidden) {
        notificationBoxHeight += BUTTON_ROW_HEIGHT + OFFSET;
    }
    
    self.notificationBox.frame = CGRectMake(0, -notificationBoxHeight, totalWidth, notificationBoxHeight);
    self.notificationBox.hidden = NO;
    
    // set text & dimensions for notification label
    self.notificationLabel.frame = CGRectMake(OFFSET + (totalWidth - messageSize.width)/2, OFFSET , messageSize.width, messageSize.height);
    
    // set text & dimensions for buttons, if visible
    if (!self.buttonView.hidden) {
        [self.confirmButton setTitle:@"OK!" forState:UIControlStateNormal];
        [self.abortButton setTitle:@"Cancel!" forState:UIControlStateNormal];
        
        [self.confirmButton sizeToFit];
        [self.abortButton sizeToFit];
        CGRect abortButtonFrame = self.abortButton.frame;
        abortButtonFrame.origin.x = OFFSET + self.confirmButton.frame.size.width;
        self.abortButton.frame = abortButtonFrame;
        
        float buttonsWidth = self.confirmButton.frame.size.width + OFFSET + self.abortButton.frame.size.width;
        self.buttonView.frame = CGRectMake(OFFSET + (totalWidth-buttonsWidth)/2, 2*OFFSET + messageSize.height, buttonsWidth, MAX(self.confirmButton.frame.size.height, self.abortButton.frame.size.height));
    }    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // animate fly-in
        self.notificationBox.frame = CGRectMake(0, 0, self.view.frame.size.width, messageSize.height+ 2*OFFSET);
    } completion:^(BOOL finished) {
        // when no buttons are shown, we schedule a fly-out after 5 seconds
        if (self.buttonView.hidden) {
            
            [UIView animateWithDuration:0.3 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.notificationBox.frame = CGRectMake(0, -(messageSize.height + 2*OFFSET), self.view.frame.size.width, messageSize.height+ 2*OFFSET);
            } completion:^(BOOL finished) {
            }];
        }
    }];
}

- (void) showInfo:(NSString*) message {
    
    self.notificationBox.backgroundColor = [UIColor yellowColor];
    self.notificationLabel.text = message;
    [self layoutNotificationBox];
}

- (void) showError:(NSString*) message {
    self.notificationBox.backgroundColor = [UIColor redColor];
        self.notificationLabel.text = message;
    [self layoutNotificationBox];
}

- (void) hideMessage {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notificationBox.frame = CGRectMake(0, -(self.notificationBox.frame.size.height + 2*OFFSET), self.view.frame.size.width, self.notificationBox.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void) showPrompt:(NSString*) message: (NSString*) confirmMessage: (NSString*) abortMessage: (PromptConfirmedBlock) onConfirm {
    
    
}

@end
