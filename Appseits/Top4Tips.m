//
//  Top4Tips.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Top4Tips.h"

@implementation Top4Tips

@synthesize allTeams = _allTeams;

@synthesize firstTeam = _firstTeam;
@synthesize secondTeam = _secondTeam;
@synthesize thirdTeam = _thirdTeam;
@synthesize fourthTeam = _fourthTeam;

+ (Top4Tips*) fromJson: (NSDictionary*) jsonData {
    
    Top4Tips *tips = [[Top4Tips alloc] init];
    
    tips.firstTeam = [jsonData objectForKey:@"first"];
    tips.secondTeam = [jsonData objectForKey:@"second"];
    tips.thirdTeam = [jsonData objectForKey:@"third"];
    tips.fourthTeam = [jsonData objectForKey:@"fourth"];
    return tips;
}

@end
