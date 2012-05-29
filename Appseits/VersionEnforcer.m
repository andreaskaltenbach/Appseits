//
//  VersionEnforcer.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-05-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VersionEnforcer.h"

@interface VersionEnforcer()

@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *requiredVersion;
@property (nonatomic, strong) NSString *latestVersion;
@property id<VersionDelegate> delegate;

@end

@implementation VersionEnforcer

@synthesize appVersion = _appVersion;
@synthesize requiredVersion = _requiredVersion;
@synthesize latestVersion = _latestVersion;
@synthesize delegate = _delegate;

+ (id) init:(id<VersionDelegate>) delegate {
    VersionEnforcer *enforcer = [[VersionEnforcer alloc] init];
    enforcer.delegate = delegate;
    return enforcer;
}

- (void) checkVersion:(NSString*) url {
    
    // fetch version information
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSHTTPURLResponse *response;
    NSData *versionData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:versionData
                          options:kNilOptions 
                          error:&error];
    

    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.requiredVersion = [json objectForKey:@"lastSupportedVersion"];
    self.latestVersion = [json objectForKey:@"lastVersion"];
    
    if (!self.isRequiredVersionSatisfied) {
        [self.delegate updateRequired:self.requiredVersion];
    }
    
    if (!self.isLatestVersionSatisfied) {
        [self.delegate newVersionAvailable:self.latestVersion];
    }
}


- (BOOL) isVersionSatisfied:(NSString*) version {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSArray *appVersionParts = [self.appVersion componentsSeparatedByString: @"."];
    NSArray *versionParts = [version componentsSeparatedByString: @"."];
    
    int counter = 0;
    int maxCount = MAX([appVersionParts count], [versionParts count]);
    
    while (counter < maxCount) {
        
        if ([appVersionParts count] <= counter) {
            return NO;
        }
        NSString *appVersionPart = [appVersionParts objectAtIndex:counter];
        
        if ([versionParts count] <= counter) {
            return YES;
        }
        NSString *versionPart = [versionParts objectAtIndex:counter];
        
        NSNumber *appNumber = [formatter numberFromString:appVersionPart];
        NSNumber *versionNumber = [formatter numberFromString:versionPart];
        
        if (appNumber.intValue < versionNumber.intValue) {
            return NO;
        }
        
        counter++;
        
    }
    
    return YES;
    
}


- (BOOL) isRequiredVersionSatisfied {
    return [self isVersionSatisfied:self.requiredVersion];
}

- (BOOL) isLatestVersionSatisfied {
    return [self isVersionSatisfied:self.latestVersion];
}


@end
