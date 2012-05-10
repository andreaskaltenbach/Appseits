//
//  Selector.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Selector : UIButton

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *flag;

+ (id) selector;

@end
