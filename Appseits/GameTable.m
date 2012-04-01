//
//  GameTable.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTable.h"
#import "GameResultCelll.h"
#import "GamePredictionCell.h"

@interface GameTable()
@property (nonatomic, strong) NSMutableArray *matchDays;
@property (nonatomic, strong) NSMutableArray *matches;
@end

@implementation GameTable
@synthesize round = _round;
@synthesize matchDays = _matchDays;
@synthesize matches = _matches;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void) setRound:(TournamentRound *)round {
    _round = round;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.matchDays = [NSMutableArray array];
    self.matches = [NSMutableArray array];
    
    for (Game* game in round.games) {

        // add match date to list of match days
        NSString *matchDate = [dateFormatter stringFromDate:game.kickOff];
        if (![self.matchDays containsObject:matchDate]) {
            [self.matchDays addObject:matchDate];
        }
        
        // add the match itself to the list of matches per day
        int index = [self.matchDays indexOfObject:matchDate];
        if (index >= [self.matches count]) {
            [self.matches addObject:[NSMutableArray arrayWithObject:game]];
        }
        else {
            NSMutableArray *matches = [self.matches objectAtIndex:index];
            [matches addObject:game];
        }
    }

    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.matchDays count]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *games = [self.matches objectAtIndex:section];
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gameResultCell = @"gameResultCell";
    NSString *gamePredictionCell = @"gamePredictionCell";
    
    NSArray *games = [self.matches objectAtIndex:indexPath.section];
    Game *game = [games objectAtIndex:indexPath.row];
    
    if (self.round.locked) {
        GameResultCelll * cell = [tableView dequeueReusableCellWithIdentifier:gameResultCell];
        cell.game = game;
        return cell;
    }
    else {
        GamePredictionCell * cell = [tableView dequeueReusableCellWithIdentifier:gamePredictionCell];
        cell.game = game;
        return cell;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    NSString *matchDay = [self.matchDays objectAtIndex:section];
    label.text = matchDay;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
