//
//  Top4Selector.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "Selector.h"

@interface Top4Selector : Selector

@property (nonatomic, strong) Team *team;

+ (id) selector;

@end
