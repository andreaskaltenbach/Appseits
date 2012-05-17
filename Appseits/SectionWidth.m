//
//  SectionWidth.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SectionWidth.h"
#import "Timeline.h"

@implementation SectionWidth

@synthesize section = _section;
@synthesize width = _width;

+ (NSArray*) sectionWidths:(NSArray*) timelineSections:(float) timelineWidth {
    
    int matchCount = [self getMatchCount:timelineSections];
    float matchWidth = timelineWidth/matchCount;
    
    // get the remaining width after all sections got their minimum
    float remainingWidth = timelineWidth - [timelineSections count] * MIN_SECTION_WIDTH;
    NSLog(@"Remaining width: %f", remainingWidth);
    
    // calculate the number of matches which demand more width
    int matchesWithMoreWidth = [self matchesDemandingMoreWidth:timelineSections :matchWidth];

    NSMutableArray *sectionWidths = [NSMutableArray array];
    for (MatchRoundGraph *section in timelineSections) {
        float sectionWidth = (float) matchWidth * [section.round.matches count];
        if (sectionWidth > MIN_SECTION_WIDTH) {
            // section demands more width -> calculate it
            
            float sectionWidth = MIN_SECTION_WIDTH + ((float)[section.round.matches count] / matchesWithMoreWidth) *remainingWidth;
            [sectionWidths addObject:[SectionWidth init:section :sectionWidth]];
        }
        else {
            // section fits into the minimum width
            [sectionWidths addObject:[SectionWidth init:section :MIN_SECTION_WIDTH]];
        }
    }               
    return sectionWidths;
}

+ (int) matchesDemandingMoreWidth:(NSArray*) sections:(float) matchWidth  {
    int matchesWithMoreWidth = 0;
    for (MatchRoundGraph* section in sections) {
        float sectionWidth = (float) matchWidth * [section.round.matches count];
        if (sectionWidth > MIN_SECTION_WIDTH) {
            matchesWithMoreWidth += [section.round.matches count];
        }
    }
    return matchesWithMoreWidth;
}

+ (int) getMatchCount:(NSArray*) sections {
    int matches = 0;
    // count all the games
    for (MatchRoundGraph *section in sections) {
        matches += [section.round.matches count];
    }
    return matches;
}

+ (SectionWidth*) init:(MatchRoundGraph*) section:(float) width {
    SectionWidth* sectionwidth = [[SectionWidth alloc] init];
    sectionwidth.section = section;
    sectionwidth.width = width;
    return sectionwidth;
}

@end
