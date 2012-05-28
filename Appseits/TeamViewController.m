//
//  TeamTableViewControllerViewController.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeamViewController.h"
#import "BackendAdapter.h"
#import "TeamCell.h"
#import "UIColor+AppColors.h"

static UIImage* firstTeamTrophy;
static UIImage* secondTeamTrophy;
static UIImage* thirdTeamTrophy;
static UIImage* fourthTeamTrophy;

@interface TeamViewController()
@property (strong, nonatomic) IBOutlet UIImageView *trophyImage;
@end

@implementation TeamViewController
@synthesize trophyImage = _trophyImage;
@synthesize overviewController = _overviewController;
@synthesize table = _table;

+ (void) initialize {
    firstTeamTrophy = [UIImage imageNamed:@"first"];
    secondTeamTrophy = [UIImage imageNamed:@"second"];
    thirdTeamTrophy = [UIImage imageNamed:@"third"];
    fourthTeamTrophy = [UIImage imageNamed:@"fourth"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return YES;
        default:
            return NO;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.table.delegate = self.overviewController;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor squareBackground];
    
    if (self.overviewController.currentTeamSelection) {
        int index = [self.overviewController.allTeams indexOfObject:self.overviewController.currentTeamSelection];
        [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    [self showTrophy];
}

- (void)viewDidUnload {
    [self setTable:nil];
    [self setTrophyImage:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.overviewController.allTeams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *teamCell = @"teamCell";
    
    Team *team = [self.overviewController.allTeams objectAtIndex:indexPath.row];
    TeamCell * cell = [tableView dequeueReusableCellWithIdentifier:teamCell];
    cell.team = team;
    
    return cell;
    
}

- (void) showTrophy {
    switch (self.overviewController.currentTeamPlace) {
        case 1:
            self.trophyImage.image = firstTeamTrophy;
            break;
        case 2:
            self.trophyImage.image = secondTeamTrophy;
            break;
        case 3:
            self.trophyImage.image = thirdTeamTrophy;
            break;
        case 4:
            self.trophyImage.image = fourthTeamTrophy;
            break;
        default:
            break;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
