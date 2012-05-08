//
//  AppseitsAppDelegate.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppseitsAppDelegate.h"
#import "TestFlight.h"
#import "VersionEnforcer.h"

@implementation AppseitsAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Test Flight
    [TestFlight takeOff:@"a6badd340afc21aca5e16d40e68bf450_NzU4OTgyMDEyLTA0LTI2IDEzOjMwOjI3LjAyODIwOA"];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Active!");
    
    VersionEnforcer *versionEnforcer = [VersionEnforcer init:self];
    [versionEnforcer checkVersion:@"http://dl.dropbox.com/u/15650647/version.json"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma marks VersionDelegate

- (void) updateRequired:(NSString*) versionNumber {
    NSLog(@"Update required: %@", versionNumber);
}

- (void) newVersionAvailable:(NSString*) versionNumber {
    NSLog(@"New version available: %@", versionNumber);
}


@end
