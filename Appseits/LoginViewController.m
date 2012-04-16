//
//  LoginViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "BackendAdapter.h"

@interface LoginViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *usernameField;

@end

@implementation LoginViewController
@synthesize usernameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // do we have valid credentials?
    BOOL validCredentials = [BackendAdapter validateCredentials];
    
    if (validCredentials) {
        [BackendAdapter initializeModel];
        [self performSegueWithIdentifier:@"toOverview" sender:self];
    }
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (IBAction)loginButtonClicked:(id)sender {
}

@end
