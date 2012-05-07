//
//  Top4Tips.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4Tips.h"
#import "BackendAdapter.h"

@implementation Top4Tips

@synthesize firstTeam = _firstTeam;
@synthesize secondTeam = _secondTeam;
@synthesize thirdTeam = _thirdTeam;
@synthesize fourthTeam = _fourthTeam;

+ (Top4Tips*) fromJson: (NSDictionary*) jsonData {
    
    NSArray* allTeams = [BackendAdapter teams];
    
    Top4Tips *tips = [[Top4Tips alloc] init];
    
    NSNumber *first = [jsonData objectForKey:@"first"];
    NSNumber *second = [jsonData objectForKey:@"second"];
    NSNumber *third = [jsonData objectForKey:@"third"];
    NSNumber *fourth = [jsonData objectForKey:@"fourth"];
    
    for (Team* team in allTeams) {
        
        if (first && [team.teamId isEqualToNumber:first]) {
            tips.firstTeam = team;
        }
        if (second && [team.teamId isEqualToNumber:second]) {
            tips.secondTeam = team;
        }
        if (third && [team.teamId isEqualToNumber:third]) {
            tips.thirdTeam = team;
        }
        if (fourth && [team.teamId isEqualToNumber:fourth]) {
            tips.fourthTeam = team;
        }
    }
    
    return tips;
}

@end
