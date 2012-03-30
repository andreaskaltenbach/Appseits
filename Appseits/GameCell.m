//
//  GameCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCell.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>

@interface GameCell() 
@property (nonatomic, strong) UIImageView *firstTeamImage;
@property (nonatomic, strong) UIImageView *secondTeamImage;
@property (nonatomic, strong) UILabel *firstTeamName;
@property (nonatomic, strong) UILabel *secondTeamName;
@end

@implementation GameCell

@synthesize game = _game;
@synthesize firstTeamImage = _firstTeamImage;
@synthesize secondTeamImage = _secondTeamImage;
@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [UIColor gameCellGradient];
        [self.layer insertSublayer:gradient atIndex:0];
        
        self.firstTeamName = (UILabel*) [self viewWithTag:1];
        self.firstTeamImage = (UIImageView*) [self viewWithTag:11];
        
        self.secondTeamName = (UILabel*) [self viewWithTag:2];
        self.secondTeamImage = (UIImageView*) [self viewWithTag:22]; 

    }
    return self;
}

- (void) fetchFlagImage:(NSString*) teamName: (UIImageView*) imageView {
    NSURL *flagUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.uefa.com/imgml/flags/18x18/%@.png", teamName]];
    NSURLRequest* flagRequest = [NSURLRequest requestWithURL:flagUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:flagRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        imageView.image = [UIImage imageWithData:data];
    }];
}

- (void) setGame:(Game *)game {
    
    NSString *firstTeam = [game.firstTeamName uppercaseString];
    NSString *secondTeam = [game.secondTeamName uppercaseString];
    self.firstTeamName.text = firstTeam;
    [self fetchFlagImage:firstTeam :self.firstTeamImage];

    self.secondTeamName.text = secondTeam;
    [self fetchFlagImage:secondTeam :self.secondTeamImage];    
    
}

@end
