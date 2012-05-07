//
//  TeamCell.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "AppseitsSelectionCell.h"

@interface TeamCell : AppseitsSelectionCell

@property (nonatomic, strong) Team *team;

@end
