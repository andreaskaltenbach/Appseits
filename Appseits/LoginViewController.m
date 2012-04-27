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

@interface LoginViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *usernameField;
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
@synthesize usernameField;
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
static UIImage *loginButtonImage;
static UIImage *forgotPasswordButtonImage;

+ (void) initialize {
    backgroundImage = [UIImage imageNamed:@"Default"];
    loginButtonImage = [UIImage imageNamed:@"login"];
    forgotPasswordButtonImage = [UIImage imageNamed:@"forgotPassword"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 2);
    self.scrollView.contentOffset = CGPointMake(0, 20);
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    
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
}

- (void) showInputs {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    self.loginView.hidden = NO;
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
            [self showInputs];
        }
    }];

}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
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
    
    // store username and password as user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.emailInput.text forKey:@"email"];
    [userDefaults setObject:self.passwordInput.text forKey:@"password"];
    [userDefaults synchronize];
    
    [self login];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            return [[UIDevice currentDevice].model isEqualToString:@"iPad"];
        default:
            return YES;
    }
}

- (IBAction)loginButtonClicked:(id)sender {
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
