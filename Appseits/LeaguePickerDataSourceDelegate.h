//
//  LeaguePickerDataSource.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaguePickerDataSourceDelegate : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>

+ (LeaguePickerDataSourceDelegate*) instance;

@end
