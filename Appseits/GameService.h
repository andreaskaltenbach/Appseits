//
//  MatchService.h
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SuccessBlock)(NSArray *matches);
typedef void(^FailedBlock)(NSString * errorMessage);

@interface GameService : NSObject

+ (void) getGames:(SuccessBlock) onSuccess: (FailedBlock) onError;


@end
