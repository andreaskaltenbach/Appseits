//
//  MatchCellCell.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface MatchCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) Match *match;

@end
