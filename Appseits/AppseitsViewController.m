//
//  AppseitsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsViewController.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_OFFSET 25

#define BUTTON_ROW_HEIGHT 40

#define TOP_MARGIN 10
#define SIDE_MARGIN 20

#define SHADOW_HEIGHT 10

#define ICON_X_INSET 9
#define ICON_Y_INSET 9

static UIFont *messageFont;
static UIImage* confirmationImage;
static UIImage* promptImage;
static UIImage* errorImage;

static UIImage* abortButtonImage;
static UIImage* confirmButtonImage;

@interface AppseitsViewController ()
@property (nonatomic, strong) SSGradientView *notificationBox;
@property (nonatomic, strong) UILabel *notificationLabel;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *abortButton;
@property (nonatomic, strong) PromptConfirmedBlock confirmAction;
@property (nonatomic, strong) UIImageView* notificationIcon;
@end

@implementation AppseitsViewController
@synthesize notificationLabel = _notificationLabel;
@synthesize notificationBox = _notificationBox;
@synthesize confirmButton = _confirmButton;
@synthesize abortButton = _abortButton;
@synthesize buttonView = _buttonView;
@synthesize confirmAction = _confirmAction;
@synthesize notificationIcon = _notificationIcon;

+ (void) initialize {
    messageFont = [UIFont systemFontOfSize:14];
    confirmationImage = [UIImage imageNamed:@"greenBallCheck"];
    promptImage = [UIImage imageNamed:@"promptIcon"];
    errorImage = [UIImage imageNamed:@"errorIcon"];
    
    confirmButtonImage = [[UIImage imageNamed:@"promptConfirmButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
    abortButtonImage = [[UIImage imageNamed:@"abortButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
}

- (UIView*) notificationBox {
    if (_notificationBox) return _notificationBox;
    
    // setup notification box
    _notificationBox = [[SSGradientView alloc] init];
    _notificationBox.layer.borderWidth = 1;
    _notificationBox.layer.shadowColor = [[UIColor blackColor] CGColor];
    _notificationBox.layer.shadowRadius = SHADOW_HEIGHT;
     _notificationBox.layer.shadowOffset = CGSizeMake(0, 10);
    _notificationBox.layer.shadowOpacity = 0.5;
    _notificationBox.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _notificationBox.frame = CGRectMake(SIDE_MARGIN, -SHADOW_HEIGHT, 1000, 1);
    [self.view addSubview:_notificationBox];
    
    // setup label
    self.notificationLabel = [[UILabel alloc] init];
    self.notificationLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.notificationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.notificationLabel.backgroundColor = [UIColor clearColor];
    self.notificationLabel.numberOfLines = 0;
    self.notificationLabel.textAlignment = UITextAlignmentCenter;
    self.notificationLabel.font = messageFont;
    [_notificationBox addSubview:self.notificationLabel];
    
    // setup button view
    self.buttonView = [[UIView alloc] init];
    self.buttonView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.buttonView.hidden = YES;
    
    self.abortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.abortButton setBackgroundImage:abortButtonImage forState:UIControlStateNormal];
    [self.abortButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAbort)]];
    [self.buttonView addSubview:self.abortButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setBackgroundImage:confirmButtonImage forState:UIControlStateNormal];
    [self.confirmButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConfirm)]];
    [self.buttonView addSubview:self.confirmButton];

    [_notificationBox addSubview:self.buttonView];
    
    // setup notification icon
    self.notificationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1000, 42, 42)];
    [self.view addSubview:self.notificationIcon];
    
    return _notificationBox;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutNotificationBox];
}

- (void) layoutNotificationBox {
    
    float totalWidth = self.view.frame.size.width - 2*SIDE_MARGIN;
    
    // calculate dimensions for the text
    CGSize messageSize = [self.notificationLabel.text sizeWithFont:messageFont constrainedToSize:CGSizeMake( totalWidth - 2*TEXT_OFFSET, 9999) lineBreakMode:UILineBreakModeWordWrap];
        
    // set dimensions of the notification box
    float notificationBoxHeight = TEXT_OFFSET + messageSize.height + TEXT_OFFSET;
    
    // make box bigger, if buttons are visible
    if (!self.buttonView.hidden) {
        notificationBoxHeight += BUTTON_ROW_HEIGHT + TEXT_OFFSET;
    }
    
    self.notificationBox.frame = CGRectMake(SIDE_MARGIN, -notificationBoxHeight, totalWidth, notificationBoxHeight);
    self.notificationIcon.frame = CGRectMake(SIDE_MARGIN - ICON_X_INSET, -notificationBoxHeight, 42, 42);
    
    // set text & dimensions for notification label
    self.notificationLabel.frame = CGRectMake((totalWidth - messageSize.width)/2, TEXT_OFFSET , messageSize.width, messageSize.height);
    
    // set text & dimensions for buttons, if visible
    if (!self.buttonView.hidden) {
        // [self.abortButton sizeToFit];
//        self.abortButton.frame = CGRectMake(0, 0,120, 38);

        [self.abortButton sizeToFit];
        [self.confirmButton sizeToFit];
        
        NSLog(@"%f",
              self.abortButton.frame.size.width );
        
        CGRect confirmButtonFrame = self.confirmButton.frame;
        confirmButtonFrame.origin.x = TEXT_OFFSET + self.abortButton.frame.size.width;
        self.confirmButton.frame = confirmButtonFrame;
        
        float buttonsWidth = self.confirmButton.frame.size.width + TEXT_OFFSET + self.abortButton.frame.size.width;
        self.buttonView.frame = CGRectMake((totalWidth-buttonsWidth)/2, 2*TEXT_OFFSET + messageSize.height, buttonsWidth, MAX(self.confirmButton.frame.size.height, self.abortButton.frame.size.height));
    }    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // animate fly-in
        self.notificationBox.frame = CGRectMake(SIDE_MARGIN, TOP_MARGIN, totalWidth, notificationBoxHeight);
        self.notificationIcon.frame = CGRectMake(SIDE_MARGIN - ICON_X_INSET, TOP_MARGIN - ICON_Y_INSET, 42, 42);

    } completion:^(BOOL finished) {
        // when no buttons are shown, we schedule a fly-out after a few seconds
        if (self.buttonView.hidden) {
            [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self hideNotification];
            } completion:^(BOOL finished) {
            }];
        }
    }];
}

- (void) showInfo:(NSString*) message {
    
    self.notificationBox.colors = [UIColor confirmationGradient];
    self.notificationBox.layer.borderColor = [[UIColor confirmationBorder] CGColor];
    self.notificationIcon.image = confirmationImage;

    
    self.notificationLabel.text = message;
    self.buttonView.hidden = YES;
    [self layoutNotificationBox];
}

- (void) showError:(NSString*) message {
    self.notificationBox.colors = [UIColor errorGradient];
    self.notificationBox.layer.borderColor = [[UIColor errorBorder] CGColor];
    self.notificationIcon.image = errorImage;
    
    self.notificationLabel.text = message;
    self.buttonView.hidden = YES;

    [self layoutNotificationBox];
}

- (void) hideNotification {
    float totalWidth = self.view.frame.size.width - 2*SIDE_MARGIN;
    self.notificationBox.frame = CGRectMake(SIDE_MARGIN, -(self.notificationBox.frame.size.height + 2*TEXT_OFFSET + SHADOW_HEIGHT), totalWidth, self.notificationBox.frame.size.height);
    self.notificationIcon.frame = CGRectMake(SIDE_MARGIN - ICON_X_INSET,  -(self.notificationBox.frame.size.height + 2*TEXT_OFFSET + SHADOW_HEIGHT)  - ICON_Y_INSET, 42, 42);
}

- (void) showPrompt:(NSString*) message: (NSString*) confirmMessage: (NSString*) abortMessage: (PromptConfirmedBlock) onConfirm {
    
    self.notificationBox.colors = [UIColor confirmationGradient];
    self.notificationBox.layer.borderColor = [[UIColor confirmationBorder] CGColor];
    self.notificationIcon.image = promptImage;

    self.buttonView.hidden = NO;
    self.notificationLabel.text = message;
    [self.confirmButton setTitle:confirmMessage forState:UIControlStateNormal];
    [self.abortButton setTitle:abortMessage forState:UIControlStateNormal];
    self.confirmAction = onConfirm;
    [self layoutNotificationBox];
}

- (void) onConfirm {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self hideNotification];
    } completion:^(BOOL finished) {
    }];
    self.confirmAction();
}

- (void) onAbort {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self hideNotification];
    } completion:^(BOOL finished) {
    }];
}


@end
