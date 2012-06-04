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

#define SPINNER_DIMENSION 50

@interface RankingTable()
@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) League* league;
@end

@implementation RankingTable

@synthesize loadingView = _loadingView;
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

- (UIView*) loadingView {
    if (!_loadingView) {;
    
        _loadingView = [[UIView alloc] initWithFrame:self.overviewViewController.rankingView.bounds];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _loadingView.backgroundColor = [UIColor whiteColor];
        _loadingView.alpha = 0.6;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.overviewViewController.rankingView.bounds.size.width/2 - SPINNER_DIMENSION/2, self.overviewViewController.rankingView.bounds.size.height/2 - SPINNER_DIMENSION/2, SPINNER_DIMENSION, SPINNER_DIMENSION)];
        spinner.color = [UIColor darkGreen];
        spinner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
        [self.overviewViewController.rankingView addSubview:_loadingView];
    }
    return _loadingView;
}

- (void) refreshRankings {
    
    // the league has changed -> refresh the ranking
    
    
    if (self.league != BackendAdapter.currentLeague) {
        self.league = BackendAdapter.currentLeague;
        
        self.loadingView.hidden = NO;
        
        [BackendAdapter loadRankings:^(RemoteCallResult remoteResult) {
            
            switch (remoteResult) {
                case NO_INTERNET:
                    [self.overviewViewController showError:@"No internet"];
                    break;
                    
                case INTERNAL_SERVER_ERROR:
                case INTERNAL_CLIENT_ERROR:
                    [self.overviewViewController showError:@"Internal"];
                    break;
                    
                case OK:
                    
                    [self.overviewViewController updateRankingInScoreView]; 
                    [self scrollToMyself];
                    
                    [self reloadData];
                    
                                        break;
                    
            }
            self.loadingView.hidden = YES;
        }];

    }
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
    
    [self.overviewViewController performSegueWithIdentifier:@"toCompetitorStatistic" sender:self];
    
}



@end
