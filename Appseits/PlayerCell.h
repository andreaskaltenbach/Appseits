//
//  PlayerCell.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsSelectionCell.h"
#import "Player.h"

@interface PlayerCell : AppseitsSelectionCell

@property (nonatomic, strong) Player *player;

@end
