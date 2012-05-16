//
//  SettingsViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "BackendAdapter.h"
#import "UIColor+AppColors.h"

#define EXTERN_IMAGE_WIDTH 13
#define EXTERN_IMAGE_HEIGHT 12

static UIImage *backgroundImage;
static UIImage *envelopeImage;
static UIImage *externImage;

static NSURL *facebookAppUrl;
static NSURL *facebookWebUrl;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *envelopeImage;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;


@end

@implementation SettingsViewController
@synthesize emailLabel = _emailLabel;
@synthesize envelopeImage = _envelopeImage;
@synthesize facebookButton = _facebookButton;
@synthesize logoutButton = _logoutButton;
@synthesize overviewViewController = _overviewViewController;

+ (void) initialize {
    backgroundImage = [UIImage imageNamed:@"settingsBackground"];
    envelopeImage = [UIImage imageNamed:@"envelope"];
    externImage = [UIImage imageNamed:@"extern"];
    
    facebookAppUrl = [NSURL URLWithString:@"fb://group/219951568114692/"];
    facebookWebUrl = [NSURL URLWithString:@"http://www.facebook.com/groups/219951568114692/"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.envelopeImage.image = envelopeImage;
    
    // add separator line above facebook button
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.facebookButton.frame.origin.y, 320, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [self.view addSubview:separator];
    
    // setup facebook button
    UILabel *facebookLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.facebookButton.frame.size.width, self.facebookButton.frame.size.height)];
    facebookLabel.text = @"EM-Tipsets Facebook-grupp";
    facebookLabel.backgroundColor = [UIColor clearColor];
    facebookLabel.textColor = [UIColor whiteColor];
    facebookLabel.font = [UIFont systemFontOfSize:16];
    [self.facebookButton addSubview:facebookLabel];
    UIImageView *externImageView = [[UIImageView alloc] initWithImage:externImage];
    externImageView.frame = CGRectMake(228, (self.facebookButton.frame.size.height - EXTERN_IMAGE_HEIGHT)/2, EXTERN_IMAGE_WIDTH, EXTERN_IMAGE_HEIGHT);
    [self.facebookButton addSubview:externImageView];
    
    // add separator line above logout button
    separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.logoutButton.frame.origin.y, 320, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [self.view addSubview:separator];
    
    // setup logout button
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.self.logoutButton.frame.size.width, self.logoutButton.frame.size.height)];
    logoutLabel.text = @"Logga ut";
    logoutLabel.backgroundColor = [UIColor clearColor];
    logoutLabel.textColor = [UIColor whiteColor];
    logoutLabel.font = [UIFont systemFontOfSize:16];
    [self.logoutButton addSubview:logoutLabel];
    
    // set email address
    self.emailLabel.text = [BackendAdapter email];
}

- (void)viewDidUnload
{
    [self setEmailLabel:nil];
    [self setEnvelopeImage:nil];
    [self setFacebookButton:nil];
    [self setLogoutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) returnToMainView {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)facebookButtonTapped:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:facebookAppUrl]) {
        [[UIApplication sharedApplication] openURL:facebookAppUrl];
    }
    else {
        [[UIApplication sharedApplication] openURL:facebookWebUrl];
    }
}

- (IBAction)logoutButtonTapped:(id)sender {
    [BackendAdapter logout];
    [self dismissModalViewControllerAnimated:YES];
    [self.overviewViewController.navigationController popViewControllerAnimated:YES];
}

@end
