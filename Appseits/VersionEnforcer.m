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
    
    if (!self.isVersionSatisfied) {
        [self.delegate updateRequired:self.requiredVersion];
    }
    
    if (![self.appVersion isEqualToString:self.latestVersion]) {
        [self.delegate newVersionAvailable:self.latestVersion];
    }
}

- (BOOL) isVersionSatisfied {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSArray *appVersionParts = [self.appVersion componentsSeparatedByString: @"."];
    NSArray *requiredVersionParts = [self.requiredVersion componentsSeparatedByString: @"."];
    
    int counter = 0;
    int maxCount = MAX([appVersionParts count], [requiredVersionParts count]);
    
    while (counter < maxCount) {
        
        if ([appVersionParts count] <= counter) {
            return NO;
        }
        NSString *appVersionPart = [appVersionParts objectAtIndex:counter];
        
        if ([requiredVersionParts count] <= counter) {
            return YES;
        }
        NSString *requiredVersionPart = [requiredVersionParts objectAtIndex:counter];
        
        
        NSNumber *appNumber = [formatter numberFromString:appVersionPart];
        NSNumber *requiredNumber = [formatter numberFromString:requiredVersionPart];
        
        if (appNumber.intValue < requiredNumber.intValue) {
            return NO;
        }
        
        counter++;
        
    }
    
    return YES;
    
}


@end
