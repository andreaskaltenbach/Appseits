//
//  SectionWidth.h
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchSectionSelector.h"

@interface SectionWidth : NSObject

@property (nonatomic, strong) MatchSectionSelector* section;
@property float width;

+ (NSArray*) sectionWidths:(NSArray*) timelineSections:(float) timelineWidth;

@end
