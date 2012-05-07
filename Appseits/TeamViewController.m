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

@interface TeamViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation TeamViewController
@synthesize overviewController = _overviewController;
@synthesize table = _table;

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

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    self.table.delegate = self.overviewController;
    self.table.dataSource = self;
}

- (void)viewDidUnload {
    [self setTable:nil];
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

@end
