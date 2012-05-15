//
//  LoginViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "BackendAdapter.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>

#define SCROLL_OFFET 20
#define KEYBOARD_SCROLL_OFFET 80

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *inputBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LoginViewController
@synthesize emailInput;
@synthesize passwordInput;
@synthesize loginButton;
@synthesize loginView;
@synthesize spinner;
@synthesize inputBackgroundView;
@synthesize separator;
@synthesize forgotPasswordButton;
@synthesize scrollView;

static UIImage *backgroundImage;
static UIImage *backgroundImagePortrait;
static UIImage *backgroundImageLandscape;
static UIImage *loginButtonImage;
static UIImage *forgotPasswordButtonImage;

+ (void) initialize {

    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            backgroundImagePortrait = [UIImage imageNamed:@"Default-Portrait~ipad"];
            backgroundImageLandscape = [UIImage imageNamed:@"Default-Landscape~ipad"];
            break;
        default:
            backgroundImage = [UIImage imageNamed:@"Default"];
    }
    
    loginButtonImage = [UIImage imageNamed:@"login"];
    forgotPasswordButtonImage = [UIImage imageNamed:@"forgotPassword"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 2);
    self.scrollView.contentOffset = CGPointMake(0, SCROLL_OFFET);

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    }

    
    spinner.hidden = NO;
    [spinner startAnimating];
    
    loginView.hidden = YES;
    self.emailInput.delegate = self;
    self.passwordInput.delegate = self;
    
    
    self.inputBackgroundView.backgroundColor = [UIColor credentialsBackground];
    self.inputBackgroundView.layer.cornerRadius = 10;
    self.separator.backgroundColor = [UIColor credentialsSeparator];
    self.loginButton.backgroundColor = [UIColor colorWithPatternImage:loginButtonImage];
    self.forgotPasswordButton.backgroundColor = [UIColor colorWithPatternImage:forgotPasswordButtonImage];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([BackendAdapter credentialsAvailable]) {
        [self login];
    }
    else {
        [self showInputs];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void) keyboardWillShow {
    // scroll input fields up
    [self.scrollView scrollRectToVisible:CGRectMake(0, KEYBOARD_SCROLL_OFFET + SCROLL_OFFET, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

-(void) keyboardWillHide {
    // scroll back down
    [self.scrollView scrollRectToVisible:CGRectMake(0, SCROLL_OFFET, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void) showInputs {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    self.loginView.hidden = NO;
    self.emailInput.text = nil;
    self.passwordInput.text = nil;
}

- (void) login {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    [BackendAdapter validateCredentials:^(bool validCredentials) {
        if (validCredentials) {
            // initialize the app and enter it
            [BackendAdapter initializeModel:^(bool success) {
                [self.spinner stopAnimating];
                [self performSegueWithIdentifier:@"toOverview" sender:self];
            }];
        }
        else {
            // show inputs
            [self showError:@"Fel epost och lösenord"];
            [self showInputs];
        }
    }];
}

- (void)viewDidUnload
{
    [self setEmailInput:nil];
    [self setPasswordInput:nil];
    [self setLoginButton:nil];
    [self setLoginView:nil];
    [self setSpinner:nil];
    [self setInputBackgroundView:nil];
    [self setInputBackgroundView:nil];
    [self setSeparator:nil];
    [self setForgotPasswordButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)loginTabbed:(id)sender {
    [self hideMessage];
    
    if (self.emailInput.text && self.emailInput.text.length > 0
        && self.passwordInput.text && self.passwordInput.text.length > 0) {
        [BackendAdapter storeCredentials:self.emailInput.text :self.passwordInput.text];
        [self login];
    }
    else {
        [self showError:@"Epost och lösenord krävs, Epost och lösenord krävs"];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad:
            
            if (toInterfaceOrientation == UIDeviceOrientationPortrait ||
                toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImagePortrait];
            }
            else {
                self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImageLandscape];                
            }
            return YES;
        default:
            // Phone
            return toInterfaceOrientation == UIDeviceOrientationPortrait ||
            toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
