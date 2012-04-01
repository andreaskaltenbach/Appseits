//
//  RankingTable.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingTable.h"
#import "Ranking.h"

@implementation RankingTable

@synthesize rankings = _rankings;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void) setRankings:(NSArray *)rankings {
    _rankings = rankings;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rankings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gameResultCell = @"gameResultCell";
    NSString *gamePredictionCell = @"gamePredictionCell";
    
    Ranking *ranking = [self.rankings objectAtIndex:indexPath.row];

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:gameResultCell];
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.text = @"lalala";
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
