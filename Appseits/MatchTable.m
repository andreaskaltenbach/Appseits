//
//  GameTable.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchTable.h"
#import "MatchResultCell.h"
#import "UIColor+AppColors.h"
#import "TournamentRound.h"
#import "SSGradientView.h"

static    NSString *matchCell;
static    NSString *matchResultCell;

static NSDateFormatter *dateFormatter;

@interface MatchTable()
@property (nonatomic, strong) NSMutableArray *matchDays;
@property (nonatomic, strong) NSMutableArray *matches;
@end

@implementation MatchTable
@synthesize round = _round;
@synthesize matchDays = _matchDays;
@synthesize matches = _matches;
@synthesize overviewViewController = _overviewViewController;

+ (void) initialize {
    matchCell= @"matchCell";
    matchResultCell = @"matchResultCell";
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
}

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
    
    BOOL changedRound = ![_round.roundName isEqualToString:round.roundName];
    
    _round = round;
        
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
    
    if (changedRound) {
        [self scrollToMatchDay];
    }
       
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.matchDays count]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *games = [self.matches objectAtIndex:section];
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *matches = [self.matches objectAtIndex:indexPath.section];
    Match *match = [matches objectAtIndex:indexPath.row];
    
    MatchCell *cell; 
    
    if (self.round.notPassed) {
        
        if (match.matchRound.readyToBet) {
            cell = [tableView dequeueReusableCellWithIdentifier:matchCell];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:matchCell];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:matchResultCell];
    }
    cell.match = match;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.round.readyToBet || self.round.notPassed) {
        return 70;
    }
    else {
        return 108;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect tableFrame = tableView.frame;
    
    SSGradientView *sectionRow = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0, tableFrame.size.width, 20)];
    sectionRow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    
    NSString *matchDay = [self.matchDays objectAtIndex:section];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([matchDay isEqualToString:today]) {
        sectionRow.colors = [UIColor todaySectionBackground];
        sectionRow.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%@ (idag)", matchDay]; 
    }
    else {
        sectionRow.backgroundColor = [UIColor blackBackground];
        sectionRow.colors = [NSArray arrayWithObjects:[UIColor clearColor], nil];
        label.text = matchDay;
    }
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [sectionRow addSubview:label];
    return sectionRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *matches = [self.matches objectAtIndex:indexPath.section];
    Match *match = [matches objectAtIndex:indexPath.row];
    if (match.matchRound.readyToBet) {
        self.overviewViewController.currentMatchSelection = match;
        [self.overviewViewController performSegueWithIdentifier:@"toMatchPrediction" sender:self];
    }
    else {
        if (!match.matchRound.notPassed) {
            self.overviewViewController.currentMatchSelection = match;
            [self.overviewViewController performSegueWithIdentifier:@"toMatchStats" sender:self];
        }
    }
    
    // TODO - show statistics if match is closed and played
    
}

- (NSIndexPath*) indexPathForMatch: (Match*) aMatch {
    int section = 0;
    int row = 0;
    
    NSString *matchDay;
    
    for (Match* match in self.round.matches) {
        
        if (!matchDay) {
            matchDay = [dateFormatter stringFromDate:match.kickOff];
        }
        else {
            NSString *newMatchDay = [dateFormatter stringFromDate:match.kickOff];
            if  ([newMatchDay isEqualToString:matchDay]) {
                // same section, new row
                row++;
            }
            else {
                matchDay = newMatchDay;
                // new section, first row
                section++;
                row = 0;
            }
        }
        
        if (match == aMatch) {
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    
    return nil;
}

- (void) updateMatchCell:(Match*) newMatch {
    
    NSIndexPath* indexPath = [self indexPathForMatch:newMatch];
    
    if (indexPath) {
        MatchCell *matchCell = (MatchCell*) [self cellForRowAtIndexPath:indexPath];
        matchCell.match = newMatch;
    }
}

- (void) scrollToMatchDay {
    
    NSDate* now = [NSDate date];
    NSString* nowString = [dateFormatter stringFromDate:now];
    
    int section = [self.matchDays indexOfObject:nowString];
    
    if (section != NSIntegerMax) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
}

@end
