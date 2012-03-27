//
//  MatchCellCell.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GamePredictionCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) Game *game;

@end
