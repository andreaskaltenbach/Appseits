//
//  Top4Selector.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface Top4Selector : UIButton

@property (nonatomic, strong) Team *team;

+ (id) selector;


@end
