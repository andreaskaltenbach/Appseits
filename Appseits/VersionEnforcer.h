//
//  VersionEnforcer.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VersionDelegate

/*
 * Called whenever 
 */
- (void) updateRequired:(NSString*) versionNumber;

@optional
- (void) newVersionAvailable:(NSString*) versionNumber;

@end

@interface VersionEnforcer : NSObject


+ (id) init:(id<VersionDelegate>) delegate;

/*
 * Performs a synchronous version check, triggering the delegate when either an update is required
 * or when a new version is available.
 * Version information is looked up at the provided URL
 */
- (void) checkVersion:(NSString*) url;

@end
