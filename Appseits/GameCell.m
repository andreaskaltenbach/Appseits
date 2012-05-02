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
#import "SSGradientView.h"

@interface GameCell() 
@property (nonatomic, strong) UIImageView *firstTeamImage;
@property (nonatomic, strong) UIImageView *secondTeamImage;
@property (nonatomic, strong) UILabel *firstTeamName;
@property (nonatomic, strong) UILabel *secondTeamName;
@property (nonatomic, strong) UILabel *kickOff;
@property (nonatomic, strong) UIImageView *predictionBackground;
@end

@implementation GameCell

@synthesize game = _game;
@synthesize firstTeamImage = _firstTeamImage;
@synthesize secondTeamImage = _secondTeamImage;
@synthesize firstTeamName = _firstTeamName;
@synthesize secondTeamName = _secondTeamName;
@synthesize kickOff = _kickOff;
@synthesize predictionBackground = _predictionBackground;

static UIImage *backgroundImage;
static UIImage *selectedBackgroundImage;

+ (void) initialize {
    backgroundImage = [UIImage imageNamed:@"matchBoxGray"];
    selectedBackgroundImage = [UIImage imageNamed:@"matchBoxGreen"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.firstTeamName = (UILabel*) [self viewWithTag:1];
        self.firstTeamImage = (UIImageView*) [self viewWithTag:11];
        
        self.secondTeamName = (UILabel*) [self viewWithTag:2];
        self.secondTeamImage = (UIImageView*) [self viewWithTag:22]; 
        
        self.kickOff = (UILabel*) [self viewWithTag:5];
        self.predictionBackground = (UIImageView*) [self viewWithTag:555];
        
        self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
    return self;
}

- (void) fetchFlagImage:(NSString*) teamName: (UIImageView*) imageView {
    
    NSString *flagFileName = [NSString stringWithFormat:@"%@.png", teamName];
    
    // prepare the file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:flagFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        // if file already exists, simply use this
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:filePath];
        imageView.image = [UIImage imageWithData:imageData];
    }
}

- (void) setGame:(Match *)game {
    
    NSString *firstTeam = [game.firstTeamName uppercaseString];
    NSString *secondTeam = [game.secondTeamName uppercaseString];
    self.firstTeamName.text = firstTeam;
    self.secondTeamName.text = secondTeam;
    
    if (game.unknownOpponents) {
        self.firstTeamImage.image = nil;
        self.secondTeamImage.image = nil;        
    }
    else {
        [self fetchFlagImage:firstTeam :self.firstTeamImage];
        [self fetchFlagImage:secondTeam :self.secondTeamImage];  
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    self.kickOff.text = [dateFormatter stringFromDate:game.kickOff];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithPatternImage:selectedBackgroundImage];
        self.firstTeamName.textColor = [UIColor whiteColor];
        self.secondTeamName.textColor = [UIColor whiteColor];
        self.kickOff.textColor = [UIColor whiteColor];
    }
    else {
        self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        self.firstTeamName.textColor = [UIColor blackColor];
        self.secondTeamName.textColor = [UIColor blackColor];
        self.kickOff.textColor = [UIColor blackColor];
    }
}

@end
