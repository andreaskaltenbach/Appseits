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

#define ROW_HEIGHT 40
#define INPUT_ROW_HEIGHT 60

@interface LeagueSelector()
@property (nonatomic, strong) UITableView *leagueTable;
@property (nonatomic, strong) UITextField *leagueInput;
@property (nonatomic, strong) UIButton *leagueSubmit;
@property (nonatomic, strong) UIView *inputHolder;

@end

@implementation LeagueSelector
@synthesize leagueTable = _leagueTable;
@synthesize leagueInput = _leagueInput;
@synthesize leagueSubmit = _leagueSubmit;
@synthesize inputHolder = _inputHolder;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.leagueTable = (UITableView*) [self viewWithTag:1];
        
        self.inputHolder = (UIView*) [self viewWithTag:5];
        self.leagueInput = (UITextField*) [self viewWithTag:2];
        self.leagueSubmit = (UIButton*) [self viewWithTag:3];
        
        self.leagueTable.delegate = self;
        self.leagueTable.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[BackendAdapter leagues] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leagueCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Alla ligor";
    } else {
        League *league = [[BackendAdapter leagues] objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = league.name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void) setFrame:(CGRect)frame {
    
    float tableHeight = ([[BackendAdapter leagues] count] + 1) * ROW_HEIGHT;
    
    
    frame.size.height = tableHeight + INPUT_ROW_HEIGHT;

        
    
    CGRect tableFrame = self.leagueTable.frame;
    tableFrame.size.height = tableHeight;
    self.leagueTable.frame = tableFrame;
    
    NSLog(@"Table Height %f", self.leagueTable.frame.size.height);
    
    CGRect inputFrame = self.inputHolder.frame;
    inputFrame.origin.y = self.leagueTable.frame.size.height;
    self.inputHolder.frame = inputFrame;

    // TODO - max table height!
    
  
    NSLog(@"Height %f", frame.size.height);
    [super setFrame:frame];
}



@end
