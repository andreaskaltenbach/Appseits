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
    _notificationBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
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
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buttonView addSubview:self.confirmButton];
    
    self.abortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buttonView addSubview:self.abortButton];
    
    [_notificationBox addSubview:self.buttonView];
    
    return _notificationBox;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutNotificationBox:self.notificationLabel.text];
}


- (void) layoutNotificationBox:(NSString*) message {
    
    float totalWidth = self.view.frame.size.width;
    
    // calculate dimensions for the text
    CGSize messageSize = [message sizeWithFont:messageFont constrainedToSize:CGSizeMake( totalWidth - 2*OFFSET, 9999) lineBreakMode:UILineBreakModeWordWrap];
    
        
    // set dimensions of the notification box
    float notificationBoxHeight = OFFSET + messageSize.height + OFFSET;
    notificationBoxHeight += BUTTON_ROW_HEIGHT + OFFSET;
    self.notificationBox.frame = CGRectMake(0, 100, totalWidth, notificationBoxHeight);
    self.notificationBox.hidden = NO;
    
    // set text & dimensions for notification label
    NSLog(@"%f", OFFSET + (totalWidth - messageSize.width)/2);
    self.notificationLabel.frame = CGRectMake(OFFSET + (totalWidth - messageSize.width)/2, OFFSET , messageSize.width, messageSize.height);
    self.notificationLabel.text = message;
    
    // set text & dimensions for buttons
    [self.confirmButton setTitle:@"OK!" forState:UIControlStateNormal];
    [self.abortButton setTitle:@"Cancel!" forState:UIControlStateNormal];
    
    [self.confirmButton sizeToFit];
    [self.abortButton sizeToFit];
    CGRect abortButtonFrame = self.abortButton.frame;
    abortButtonFrame.origin.x = OFFSET + self.confirmButton.frame.size.width;
    self.abortButton.frame = abortButtonFrame;
    
    float buttonsWidth = self.confirmButton.frame.size.width + OFFSET + self.abortButton.frame.size.width;
    self.buttonView.frame = CGRectMake(OFFSET + (totalWidth-buttonsWidth)/2, 2*OFFSET + messageSize.height, buttonsWidth, MAX(self.confirmButton.frame.size.height, self.abortButton.frame.size.height));
    

   

    
    
    
    
    
    
    /*float messageWidth = self.view.frame.size.width - 2*OFFSET;
        
    
    float notificationBoxHeight = OFFSET + messageSize.height + OFFSET;
    notificationBoxHeight += BUTTON_ROW_HEIGHT + OFFSET; 
    
    self.notificationBox.frame = CGRectMake(0, -(messageSize.height + 2*OFFSET), self.view.frame.size.width, notificationBoxHeight);
    self.notificationLabel.frame = CGRectMake(OFFSET, OFFSET, messageSize.width, messageSize.height);
    NSLog(@"Message:%@", message);
    self.notificationLabel.text = message;
    self.notificationLabel.backgroundColor = [UIColor cyanColor];
    self.notificationBox.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{

    }];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // animate fly-in
        self.notificationBox.frame = CGRectMake(0, 100, self.view.frame.size.width, messageSize.height+ 2*OFFSET);
    } completion:^(BOOL finished) {
        // animate fly-out after 5 seconds
//        [UIView animateWithDuration:0.3 delay:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
  //          self.notificationBox.frame = CGRectMake(0, -(messageSize.height + 2*OFFSET), self.view.frame.size.width, messageSize.height+ 2*OFFSET);
            
    //    } completion:^(BOOL finished) {
            
      //  }];
    }];*/
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

- (void) showPrompt:(NSString*) message: (NSString*) confirmMessage: (NSString*) abortMessage: (PromptConfirmedBlock) onConfirm {
    
    
}

@end
