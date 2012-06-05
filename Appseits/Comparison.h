//
//  Comparison.h
//  EM Tipset
//
//  Created by AndreasKaltenbach on 2012-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comparison : NSObject

@property (nonatomic, strong) NSString* myInitials;

@property (nonatomic, strong) NSString* competitorInitials;
@property (nonatomic, strong) NSString* competitorName;

@property (nonatomic, strong) NSArray* roundComparisons;

+ (Comparison*) comparisonFromJson:(NSDictionary*) jsonData;

@end
