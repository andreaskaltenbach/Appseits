//
//  LeagueSelector.m
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-05-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeagueSelector.h"
#import "BackendAdapter.h"
#import "League.h"
#import "LeagueCell.h"
#import "NewLeagueCell.h"

#define ROW_HEIGHT 40
#define INPUT_ROW_HEIGHT 60
#define MAX_TABLE_HEIGHT 200

@interface LeagueSelector()
@property (nonatomic, strong) UITableView *leagueTable;
@end

@implementation LeagueSelector
@synthesize leagueTable = _leagueTable;
@synthesize leagueSelectionDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.leagueTable = (UITableView*) [self viewWithTag:1];
        
        self.leagueTable.delegate = self;
        self.leagueTable.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [[BackendAdapter leagues] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > [[BackendAdapter leagues] count]) {
        // it's the last cell in the table -> the new cell input cell
        NewLeagueCell* newLeagueCell = [tableView dequeueReusableCellWithIdentifier:@"newLeagueCell"];
        return newLeagueCell;
    }

    // otherwise, it's an ordinary league cell
    LeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leagueCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Superligan";
    }
    else {
        League *league = [[BackendAdapter leagues] objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = league.name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > [[BackendAdapter leagues] count]) {
        return INPUT_ROW_HEIGHT;
    }
    else {
        return ROW_HEIGHT;
    }
}

- (void) setFrame:(CGRect)frame {
    
    float tableHeight = ([[BackendAdapter leagues] count] + 1) * ROW_HEIGHT + INPUT_ROW_HEIGHT;
    frame.size.height = MIN(MAX_TABLE_HEIGHT, tableHeight);
    
    CGRect tableFrame = self.leagueTable.frame;
    tableFrame.size.height = MIN(MAX_TABLE_HEIGHT, tableHeight);
    self.leagueTable.frame = tableFrame;
    
    [super setFrame:frame];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= [[BackendAdapter leagues] count]) {
        // an existing league is selected -> inform the delegate
        if (indexPath.row == 0) {
            [self.leagueSelectionDelegate leagueSelected:nil];
        }
        else {
            int index = indexPath.row - 1;
            League *league = [[BackendAdapter leagues] objectAtIndex:index];
            [self.leagueSelectionDelegate leagueSelected:league];
        }
    }
}

@end
