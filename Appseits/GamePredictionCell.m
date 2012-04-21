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

#define MAX_GOALS 12

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
        [self.firstTeamPredictionCarousel scrollToItemAtIndex:MAX_GOALS-1 animated:YES];
    }
    
    if (game.secondTeamPrediction) {
        [self.secondTeamPredictionCarousel scrollToItemAtIndex:game.secondTeamPrediction.intValue animated:YES];
    }
    else {
        [self.secondTeamPredictionCarousel scrollToItemAtIndex:MAX_GOALS-1 animated:YES];
    }
}

#pragma mark iCarouselDataSource implementation

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return MAX_GOALS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UILabel *label;
    SSGradientView *gradientView;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
        gradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        gradientView.colors = [UIColor grayBackgroundGradient];
        
		view = gradientView;
        view.layer.borderColor = [[UIColor blackColor] CGColor];
        view.layer.borderWidth = 1;
        
		label = [[UILabel alloc] initWithFrame:view.bounds];
		label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:22];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
        gradientView = (SSGradientView*) view;
	}
	
    //set label
    if (index == MAX_GOALS-1) {
        label.text = @"-";
        label.textColor = [UIColor blackColor];
        gradientView.colors = [UIColor grayBackgroundGradient];
    }
    else {
       label.text = [NSString stringWithFormat:@"%i", index];
       label.textColor = [UIColor whiteColor];
       gradientView.colors = [UIColor greenGradient];
    }
	return view;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return 5;
}

#pragma mark iCarouselDelegate implementation

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
   
    NSLog(@"Selected %i", carousel.currentItemIndex);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // cell is not selectable
}

@end
