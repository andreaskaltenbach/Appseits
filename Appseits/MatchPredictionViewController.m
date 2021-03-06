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
#import "MatchRound.h"
#import "RoundTimeConstraintRow.h"

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
@property (strong, nonatomic) IBOutlet RoundTimeConstraintRow *roundConstraints;

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
@synthesize roundConstraints;
@synthesize overviewViewController = _overviewViewController;

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
    
    [self updateView];
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
    [self setRoundConstraints:nil];
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
    
    BOOL roundCompletedBeforeSave = self.match.matchRound.allPredictionsDone;
    
    if (self.match.firstTeamPrediction.intValue > 0) {
        NSNumber *newPrediction = [NSNumber numberWithInt:self.match.firstTeamPrediction.intValue - 1];
        self.match.firstTeamPrediction = newPrediction;
        self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", newPrediction.intValue];

        self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
        self.stalePrediction = YES;
        
        if (self.completePrediction && !roundCompletedBeforeSave && self.match.matchRound.allPredictionsDone) {
            [self showConfirmation:[NSString stringWithFormat:@"Bra! Du har tippat klart omgång %@.", self.match.matchRound.roundName]];
        }

        [self pushPrediction];
    }
}

- (IBAction)decreaseSecondTeamGoals:(id)sender {
    
    BOOL roundCompletedBeforeSave = self.match.matchRound.allPredictionsDone;
    
    if (self.match.secondTeamPrediction.intValue > 0) {
        NSNumber *newPrediction = [NSNumber numberWithInt:self.match.secondTeamPrediction.intValue - 1];
        self.match.secondTeamPrediction = newPrediction;
        self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", newPrediction.intValue];
        
        self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
        self.stalePrediction = YES;
        
        if (self.completePrediction && !roundCompletedBeforeSave && self.match.matchRound.allPredictionsDone) {
            [self showConfirmation:[NSString stringWithFormat:@"Bra! Du har tippat klart omgång %@.", self.match.matchRound.roundName]];
        }

        [self pushPrediction];
    }
    
}
- (IBAction)increaseFirstTeamGoals:(id)sender {
    
    BOOL roundCompletedBeforeSave = self.match.matchRound.allPredictionsDone;
    
    if (self.match.firstTeamPrediction) {
        NSNumber *newPreciction = [NSNumber numberWithInt:self.match.firstTeamPrediction.intValue + 1];
        self.match.firstTeamPrediction = newPreciction;
    }
    else {
        self.match.firstTeamPrediction =[NSNumber numberWithInt:0];
    }
    
    self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.firstTeamPrediction.intValue];
    
    self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
    self.stalePrediction = YES;
    
    if (self.completePrediction && !roundCompletedBeforeSave && self.match.matchRound.allPredictionsDone) {
        [self showConfirmation:[NSString stringWithFormat:@"Bra! Du har tippat klart omgång %@.", self.match.matchRound.roundName]];
    }
   
    [self pushPrediction];

}
- (IBAction)increaseSecondTeamGoals:(id)sender {
    BOOL roundCompletedBeforeSave = self.match.matchRound.allPredictionsDone;
    
    
    if (self.match.secondTeamPrediction) {
        NSNumber *newPreciction = [NSNumber numberWithInt:self.match.secondTeamPrediction.intValue + 1];
        self.match.secondTeamPrediction = newPreciction;
    }
    else {
        self.match.secondTeamPrediction =[NSNumber numberWithInt:0];
    }
    
    self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.secondTeamPrediction.intValue];
    
    self.completePrediction = self.match.firstTeamPrediction && self.match.secondTeamPrediction;
    self.stalePrediction = YES;
    
    if (self.completePrediction && !roundCompletedBeforeSave && self.match.matchRound.allPredictionsDone) {
        [self showConfirmation:[NSString stringWithFormat:@"Bra! Du har tippat klart omgång %@.", self.match.matchRound.roundName]];
    }
    
    [self pushPrediction];

}

- (void) pushPrediction {
    if (self.stalePrediction && self.completePrediction) {
        
        [self.overviewViewController.timelineScrollView refreshSections];
        [self.overviewViewController.gameTable updateMatchCell:self.match];
        
        [BackendAdapter postPrediction:self.match.matchId:self.match.firstTeamPrediction:self.match.secondTeamPrediction :^(RemoteCallResult remoteCallResult) {
            
            switch (remoteCallResult) {
                case INTERNAL_CLIENT_ERROR:
                case INTERNAL_SERVER_ERROR:
                    [self showError:@"Någonting gick fel med att spara tipset. Försök igen."];
                    break;
                case NO_INTERNET:
                    [self showError:@"Du verkar sakna uppkoppling. Försök igen."];
                    break;
                case OK:
                    self.stalePrediction = NO;
            }
        }];
    }
}

- (void) setOverviewViewController:(OverviewViewController *)overviewViewController {
    _overviewViewController = overviewViewController;
    self.roundConstraints.overviewViewController = overviewViewController;
}

- (void) updateView {
    
    self.roundConstraints.round = self.match.matchRound;

    
    self.firstTeamLabel.text = [self.match.firstTeam.shortName uppercaseString];
    if (self.match.firstTeamPrediction) {
        self.firstTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.firstTeamPrediction.intValue];
    }
    else {
        self.firstTeamGoalsLabel.text = @"-";
    }
    self.firstTeamFlag.image = self.match.firstTeam.flag;
    
    self.secondTeamLabel.text = [self.match.secondTeam.shortName uppercaseString];
    if (self.match.secondTeamPrediction) {
        self.secondTeamGoalsLabel.text = [NSString stringWithFormat:@"%i", self.match.secondTeamPrediction.intValue];
    }
    else {
        self.secondTeamGoalsLabel.text = @"-";
    }

    self.secondTeamFlag.image = self.match.secondTeam.flag;
    
    self.completePrediction = self.match.firstTeamGoals && self.match.secondTeamGoals;
    
}

- (void) setMatch:(Match *)match {
    _match = match;
    [self updateView];
}

- (IBAction)prevMatchTapped:(id)sender {
    
    Match* previousMatch = [MatchRound previousPredictableMatch:self.match];
    if (previousMatch) {
        
        if (self.match.matchRound != previousMatch.matchRound) {
            // if the next match is in the previous round, we switch to the previous round
            
            [self showInfo:[NSString stringWithFormat:@"Omgång %@", previousMatch.matchRound.roundName]];
            
            [self.overviewViewController.timelineScrollView selectTournamentRound:previousMatch.matchRound];
        }
        
        // update match info
        self.match = previousMatch;
        
        
        // move table selection to next match
        NSIndexPath* indexPath = [self.overviewViewController.gameTable indexPathForMatch: previousMatch];
        [self.overviewViewController.gameTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
    }
    else {
        [self showError:@"Det går inte att gå längre åt detta håll."];
    }

    
}

- (IBAction)nextMatchTapped:(id)sender {
    
    Match* nextMatch = [MatchRound nextPredictableMatch:self.match];
    if (nextMatch) {
        
        if (self.match.matchRound != nextMatch.matchRound) {
            // if the next match is in the next round, we switch to the next round
            
            [self showInfo:[NSString stringWithFormat:@"Omgång %@", nextMatch.matchRound.roundName]];
            
            [self.overviewViewController.timelineScrollView selectTournamentRound:nextMatch.matchRound];
        }
        
        // update match info
        self.match = nextMatch;
        
        
        // move table selection to next match
        NSIndexPath* indexPath = [self.overviewViewController.gameTable indexPathForMatch: nextMatch];
        [self.overviewViewController.gameTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        
    }
    else {
        [self showError:@"Det går inte att gå längre åt detta håll."];
    }
}



@end
