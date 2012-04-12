//
//  MatchCellCell.m
//  Appseits
//
//  Created by AndreasKaltenbach on 2012-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePredictionCell.h"
#import "Game.h"
#import "iCarousel.h"
#import "UIColor+AppColors.h"
#import "SSGradientView.h"

#define MAX_GOALS 10

@interface GamePredictionCell()

@property (nonatomic, strong) UITextField *firstTeamGoalsBet;
@property (nonatomic, strong) UITextField *secondTeamGoalsBet;
@property (nonatomic, strong) UILabel *matchResultLabel;
@property (nonatomic, strong) UILabel *pointsLabel;
@property (nonatomic, strong) iCarousel *firstTeamPredictionCarousel;
@property (nonatomic, strong) iCarousel *secondTeamPredictionCarousel;

@end

@implementation GamePredictionCell

@synthesize firstTeamGoalsBet = _firstTeamGoalsBet;
@synthesize secondTeamGoalsBet = _secondTeamGoalsBet;
@synthesize matchResultLabel = _matchResultLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize firstTeamPredictionCarousel = _firstTeamPredictionCarousel;
@synthesize secondTeamPredictionCarousel = _secondTeamPredictionCarousel;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.firstTeamPredictionCarousel = (iCarousel*) [self viewWithTag:105];
        NSLog(@"%@", self.firstTeamPredictionCarousel);
        self.firstTeamPredictionCarousel.dataSource = self;
        self.firstTeamPredictionCarousel.delegate = self;
        self.firstTeamPredictionCarousel.type = iCarouselTypeCylinder;
        self.secondTeamPredictionCarousel = (iCarousel*) [self viewWithTag:205];
        self.secondTeamPredictionCarousel.dataSource = self;
        self.secondTeamPredictionCarousel.delegate = self;
        self.secondTeamPredictionCarousel.type = iCarouselTypeCylinder;
        
    }
    
    return self;
}

- (void) setGame:(Game *)game {
    [super setGame:game];
    
    if (game.firstTeamPrediction) {
        [self.firstTeamPredictionCarousel scrollToItemAtIndex:game.firstTeamPrediction.intValue animated:YES];
    }
    else {
        [self.firstTeamPredictionCarousel scrollToItemAtIndex:0 animated:YES];
    }
    
    if (game.secondTeamPrediction) {
        [self.secondTeamPredictionCarousel scrollToItemAtIndex:game.secondTeamPrediction.intValue animated:YES];
    }
    else {
        [self.secondTeamPredictionCarousel scrollToItemAtIndex:0 animated:YES];
    }
}

#pragma mark iCarouselDataSource implementation

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return MAX_GOALS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
        SSGradientView *gradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        gradientView.colors = [UIColor greenGradient];
        
        
		view = gradientView;
        
		label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:50];
        
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
   
   label.text = [NSString stringWithFormat:@"%i", index];
	
	return view;
}

#pragma mark iCarouselDelegate implementation
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"Selected %i", index);
}


@end
