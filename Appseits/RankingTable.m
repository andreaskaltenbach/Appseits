//
//  RankingTable.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingTable.h"
#import "Ranking.h"
#import "Constants.h"
#import "UIColor+AppColors.h"
#import "RankingCell.h"
#import "BackendAdapter.h"

@interface RankingTable()


@property (nonatomic, strong) League* league;
@end

@implementation RankingTable

@synthesize league = _league;
@synthesize overviewViewController = _overviewViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.dataSource = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.scrollsToTop = NO;

    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BackendAdapter.rankings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rankingCellIdentifier = @"rankingCell";
    
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:rankingCellIdentifier];
    cell.ranking = [BackendAdapter.rankings objectAtIndex:indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        cell.even = YES;
    }
    else {
        cell.even = NO;
    }
    return cell;
}



- (void) refreshRankings {
    
    // the league has changed -> refresh the ranking
    [self reloadData];
    [self scrollToMyself];
}

- (void) scrollToMyself {
    // scroll to myself inside the list
    int counter = 0;
    for (Ranking* ranking in [BackendAdapter rankings]) {
        if (ranking.isMyRanking) {
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:counter inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
        counter++;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Ranking *ranking = [BackendAdapter.rankings objectAtIndex:indexPath.row];
    self.overviewViewController.currentCompetitorId = ranking.competitorId;
    
    //[self.overviewViewController performSegueWithIdentifier:@"toCompetitorStatistic" sender:self];
    
}



@end
