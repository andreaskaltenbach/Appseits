//
//  GameTable.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTable.h"
#import "MatchResultCell.h"
#import "GamePredictionCell.h"
#import "UIColor+AppColors.h"
#import "TournamentRound.h"

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
        self.dataSource = self;
        self.scrollsToTop = NO;
    }
    return self;
}

- (void) setRound:(MatchRound *)round {
    _round = round;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.matchDays = [NSMutableArray array];
    self.matches = [NSMutableArray array];
    
    for (Match* game in round.matches) {

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
    NSLog(@"Match days : %i", [self.matchDays count]);
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
    Match *match = [games objectAtIndex:indexPath.row];
    
    if ((match.firstTeamGoals && match.secondTeamGoals) || self.round.roundState == CLOSED) {
        MatchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:gameResultCell];
        cell.game = match;
        return cell;
    }
    else {
        GamePredictionCell * cell = [tableView dequeueReusableCellWithIdentifier:gamePredictionCell];
        cell.game = match;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect tableFrame = tableView.frame;
    
    UIView *sectionRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableFrame.size.width, 20)];
    sectionRow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sectionRow.backgroundColor = [UIColor blackBackground];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    NSString *matchDay = [self.matchDays objectAtIndex:section];
    label.text = matchDay;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [sectionRow addSubview:label];
    return sectionRow;
}

@end
