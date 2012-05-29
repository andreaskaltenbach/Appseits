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
#import "LightBlueGradient.h"

static UIImage* firstTeamTrophy;
static UIImage* secondTeamTrophy;
static UIImage* thirdTeamTrophy;

@interface TeamViewController()
@property (strong, nonatomic) IBOutlet UIImageView *trophyImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation TeamViewController
@synthesize trophyImage = _trophyImage;
@synthesize spinner = _spinner;
@synthesize loadingView = _loadingView;
@synthesize overviewController = _overviewController;
@synthesize table = _table;

+ (void) initialize {
    firstTeamTrophy = [UIImage imageNamed:@"first"];
    secondTeamTrophy = [UIImage imageNamed:@"second"];
    thirdTeamTrophy = [UIImage imageNamed:@"third"];
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

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.loadingView.hidden = NO;
    [self.spinner startAnimating];
    
    [self.overviewController tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor squareBackground];
    
    LightBlueGradient *gradient = [[LightBlueGradient alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    gradient.userInteractionEnabled = NO;
    [self.view addSubview:gradient];
    [self.view sendSubviewToBack:gradient];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = [UIColor clearColor];
    
    if (self.overviewController.currentTeamSelection) {
        int index = [self.overviewController.allTeams indexOfObject:self.overviewController.currentTeamSelection];
        [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    [self showTrophy];
}

- (void)viewDidUnload {
    [self setTable:nil];
    [self setTrophyImage:nil];
    [self setSpinner:nil];
    [self setLoadingView:nil];
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
        case 4:
            self.trophyImage.image = thirdTeamTrophy;
            break;
        default:
            break;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
