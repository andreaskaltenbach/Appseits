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
@synthesize firstTeamPoints = _firstTeamPoints;

@synthesize secondTeam = _secondTeam;
@synthesize secondTeamPoints = _secondTeamPoints;

@synthesize thirdTeam = _thirdTeam;
@synthesize thirdTeamPoints = _thirdTeamPoints;

@synthesize fourthTeam = _fourthTeam;
@synthesize fourthTeamPoints = _fourthTeamPoints;

+ (Top4Tips*) fromJson: (NSArray*) jsonData {
    
    NSDictionary* allTeams = [BackendAdapter teams];
    
    Top4Tips *tips = [[Top4Tips alloc] init];
    NSLog(@"JSON: %@", jsonData);
    
    for (NSDictionary *prediction in jsonData) {
        NSNumber *place = [prediction valueForKey:@"place"];
        NSNumber *teamId = [prediction valueForKey:@"teamId"];
        NSNumber *score = [prediction valueForKey:@"score"];
        NSLog(@"Score: %@", score);
        
        if (place.intValue != 0 && teamId != 0) {
            
            Team *team = [allTeams objectForKey:teamId];
            
            if (place.intValue == 1) {
                tips.firstTeam = team;
                tips.firstTeamPoints = score;
            }
            if (place.intValue == 2) {
                tips.secondTeam = team;
            }
            if (place.intValue == 3) {
                tips.thirdTeam = team;
                tips.thirdTeamPoints = score;
            }
            if (place.intValue == 4) {
                    tips.fourthTeam = team;
                tips.fourthTeamPoints = score;
            }
        }
    }
    
    return tips;
}


@end
