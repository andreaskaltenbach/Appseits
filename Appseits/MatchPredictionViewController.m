//
//  MatchPredictionViewController.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchPredictionViewController.h"
#import "UIColor+AppColors.h"
#import "Match.h"
#import "BackendAdapter.h"

@interface MatchPredictionViewController ()
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *firstTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTeamLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstTeamFlag;
@property (weak, nonatomic) IBOutlet UIImageView *secondTeamFlag;
@property (weak, nonatomic) IBOutlet UILabel *firstTeamGoalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTeamGoalsLabel;
@property BOOL stalePrediction;
@property BOOL completePrediction;
@end

@implementation MatchPredictionViewController
@synthesize backButton;
@synthesize firstTeamLabel;
@synthesize secondTeamLabel;
@synthesize firstTeamFlag;
@synthesize secondTeamFlag;
@synthesize firstTeamGoalsLabel;
@synthesize secondTeamGoalsLabel;
@synthesize match = _match;
@synthesize stalePrediction = _stalePrediction;
@synthesize completePrediction = _completePrediction;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor squareBackground];
    
    self.firstTeamLabel.text = [self.match.firstTeam.shortName uppercaseString];
    if (self.match.firstTeamPrediction) {
        self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.firstTeamPrediction.intValue];
    }
    self.firstTeamFlag.image = self.match.firstTeam.flag;
    
    self.secondTeamLabel.text = [self.match.secondTeam.shortName uppercaseString];
    if (self.match.secondTeamPrediction) {
        self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.secondTeamPrediction.intValue];
    }
    self.secondTeamFlag.image = self.match.secondTeam.flag;
    
    self.completePrediction = self.match.firstTeamGoals && self.match.secondTeamGoals;
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setFirstTeamLabel:nil];
    [self setSecondTeamLabel:nil];
    [self setFirstTeamFlag:nil];
    [self setSecondTeamFlag:nil];
    [self setFirstTeamGoalsLabel:nil];
    [self setSecondTeamGoalsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)decreaseFirstTeamGoals:(id)sender {
    
    if (self.match.firstTeamPrediction.intValue > 0) {
        NSNumber *newPrediction = [NSNumber numberWithInt:self.match.firstTeamPrediction.intValue - 1];
        self.match.firstTeamPrediction = newPrediction;
        self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", newPrediction.intValue];

        self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
        self.stalePrediction = YES;

        [self pushPrediction];
    }
}

- (IBAction)decreaseSecondTeamGoals:(id)sender {
    if (self.match.secondTeamPrediction.intValue > 0) {
        NSNumber *newPrediction = [NSNumber numberWithInt:self.match.secondTeamPrediction.intValue - 1];
        self.match.secondTeamPrediction = newPrediction;
        self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", newPrediction.intValue];
        
        self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
        self.stalePrediction = YES;

        [self pushPrediction];
    }
    
}
- (IBAction)increaseFirstTeamGoals:(id)sender {
    if (self.match.firstTeamPrediction) {
        NSNumber *newPreciction = [NSNumber numberWithInt:self.match.firstTeamPrediction.intValue + 1];
        self.match.firstTeamPrediction = newPreciction;
    }
    else {
        self.match.firstTeamPrediction =[NSNumber numberWithInt:1];
    }
    
    self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.firstTeamPrediction.intValue];
    
    self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
    self.stalePrediction = YES;
    
    [self pushPrediction];

}
- (IBAction)increaseSecondTeamGoals:(id)sender {
    if (self.match.secondTeamPrediction) {
        NSNumber *newPreciction = [NSNumber numberWithInt:self.match.secondTeamPrediction.intValue + 1];
        self.match.secondTeamPrediction = newPreciction;
    }
    else {
        self.match.secondTeamPrediction =[NSNumber numberWithInt:1];
    }
    
    self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.secondTeamPrediction.intValue];
    
    self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
    self.stalePrediction = YES;
    
    [self pushPrediction];

}

- (void) pushPrediction {
    if (self.stalePrediction && self.completePrediction) {
        [BackendAdapter postPrediction:self.match.matchId:self.match.firstTeamPrediction:self.match.secondTeamPrediction :^(bool success) {
            if (!success) {
                [self showError:@"Kunde tyvärr inte spara resultatet. Vänligen försök senare igen."];
            }
            self.stalePrediction = NO;
        }];
    }
}



@end
