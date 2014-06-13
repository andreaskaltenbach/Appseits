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
//#define INPUT_ROW_HEIGHT 60
#define MAX_TABLE_HEIGHT 380

@interface LeagueSelector()

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
        self.leagueTable.backgroundColor = [UIColor clearColor];
        self.leagueTable.scrollsToTop = NO;
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImage.image = [[UIImage imageNamed:@"leagueSelectBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(90, 150, 90, 150)];
        [self addSubview:backgroundImage];
        [self sendSubviewToBack:backgroundImage];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [[BackendAdapter leagues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leagueCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor whiteColor];
	cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0) {
        cell.leagueName.text = @"Alla deltagare";
    }
    else {
        League *league = [[BackendAdapter leagues] objectAtIndex:indexPath.row - 1];
        cell.leagueName.text = league.name;
    }
    
    return cell;
}

- (void) selectCurrentLeague {
    
    League *currentLeague = BackendAdapter.currentLeague;
    
    NSIndexPath* indexPath;
    if (currentLeague) {
        NSLog(@"index: %i", indexPath.row);
        indexPath = [NSIndexPath indexPathForRow:[BackendAdapter.leagues indexOfObject:currentLeague] + 1 inSection:0];
    }
    else {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.leagueTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void) setFrame:(CGRect)frame {
    
    float tableHeight = ([[BackendAdapter leagues] count] + 1) * ROW_HEIGHT;
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
