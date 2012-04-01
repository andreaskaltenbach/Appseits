//
//  Timeline.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TournamentRoundSelectDelegate.h"

@interface Timeline : UIView

@property (nonatomic, strong) NSArray *rounds;
@property (nonatomic, strong) id<TournamentRoundSelectDelegate> roundSelectDelegate;

@end
