//
//  Top4Round.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TournamentRound.h"
#import "Top4Tips.h"

@interface Top4Round : TournamentRound

+ (id) init:(Top4Tips*) top4Tips;

@property (nonatomic, strong) Top4Tips *top4Tips;

@end
