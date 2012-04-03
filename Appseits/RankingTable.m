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
#import "RankingService.h"
#import "RankingCell.h"

#define SPINNER_DIMENSION 50

@interface RankingTable()
@property (nonatomic, strong) NSArray *rankings;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation RankingTable

@synthesize rankings = _rankings;
@synthesize leagueId = _leagueId;
@synthesize loadingView = _loadingView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        // load a potential league ID stored in the user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.leagueId = [userDefaults objectForKey:LEAGUE_ID_KEY];
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rankings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *rankingCellIdentifier = @"rankingCell";
    
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:rankingCellIdentifier];
    cell.ranking = [self.rankings objectAtIndex:indexPath.row];

    return cell;
}

- (UIView*) loadingView {
    if (!_loadingView) {;
    
        _loadingView = [[UIView alloc] initWithFrame:self.bounds];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _loadingView.backgroundColor = [UIColor whiteColor];
        _loadingView.alpha = 0.8;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - SPINNER_DIMENSION/2, self.bounds.size.height/2 - SPINNER_DIMENSION/2, SPINNER_DIMENSION, SPINNER_DIMENSION)];
        spinner.color = [UIColor darkGreen];
        spinner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void) setLeagueId:(NSNumber *)leagueId {
    if (_leagueId != leagueId) {
        _leagueId = leagueId;
        
        // show spinner view and fetch new 
        self.loadingView.hidden = NO;
        
        [RankingService getRankingsForLeague:leagueId :^(NSArray *rankings) {
            self.rankings = rankings;
            [self reloadData];
            self.loadingView.hidden = YES;
            
        } :^(NSString *errorMessage) {
            NSLog(@"Failed to fetch rankings!");
        }];
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.text = @"Namn | Poäng";
    return label;
}



@end
