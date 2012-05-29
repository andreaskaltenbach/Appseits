//
//  LastUpdateView.m
//  Appseits
//
//  Created by Andreas Kaltenbach on 2012-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundTimeConstraintRow.h"
#import "UIColor+AppColors.h"
#import "OverviewViewController.h"

static UIImage *clockImage;

static NSString *closeMessage;
static NSString *openMessage;

@interface RoundTimeConstraintRow()
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RoundTimeConstraintRow

@synthesize round = _round;
@synthesize label = _label;
@synthesize timer = _timer;
@synthesize overviewViewController = _overviewViewController;

+ (void) initialize {
    clockImage = [UIImage imageNamed:@"11-clock.png"];
    
    closeMessage = @"Omgången låses om %i %@";
    openMessage = @"Omgången öppnar om %i %@";
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.colors = [UIColor lastUpdatedGradient];
        
        UIImageView *clockImageView = [[UIImageView alloc] initWithImage:clockImage];
        clockImageView.frame = CGRectMake(6, 6, 16, 16);
        [self addSubview:clockImageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 290, self.frame.size.height)];
        self.label.textColor = [UIColor lastUpdatedTextColor];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startTimer)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTimer)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [self startTimer];
    }
    return self;
}

- (void) startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(refreshLabel)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stopTimer {
    [self.timer invalidate];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setRound:(TournamentRound *)round {
    _round = round;
    [self refreshLabel];
}

- (void) refreshLabel {
    NSString *message;
    if (self.round.notPassed) {
        NSDate *now = [NSDate date];
        
        NSString* prefix;
        NSDate *referenceDate;
        if (self.round.started) {
            prefix = closeMessage;
            referenceDate = self.round.lockDate;
        }
        else {
            prefix = openMessage;
            referenceDate = self.round.startDate;
        }
        
        // Get conversion to months, days, hours, minutes
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        NSDateComponents *breakdownInfo = [sysCalendar components:NSMonthCalendarUnit fromDate:now  toDate:referenceDate options:0];
        
        if ([breakdownInfo month] > 1) {
            // lock date is several months away
            message = [NSString stringWithFormat:prefix, [breakdownInfo month], @"månader"];
        }
        else {
            // lock date is several days away
            breakdownInfo = [sysCalendar components:NSDayCalendarUnit fromDate:now  toDate:referenceDate options:0];
            if ([breakdownInfo day] > 1) {
                message = [NSString stringWithFormat:prefix, [breakdownInfo day], @"dagar"];
            }
            else {
                // lock date is several hours or minutes away
                breakdownInfo = [sysCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate: now toDate:referenceDate options:0];
                
                int hours = [breakdownInfo hour];
                int minutes = [breakdownInfo minute];
                
                if (hours > 0 || minutes > 0) {
                    
                    if (hours > 0) {
                        // timmar 
                        message = [NSString stringWithFormat:prefix, [breakdownInfo hour], @"tim"];
                        // och minuter
                        if (minutes > 0) {
                            if (minutes == 1) {
                                message = [NSString stringWithFormat:@"%@ och en min", message];
                            }
                            else {
                                message = [NSString stringWithFormat:@"%@ och %i min", message, minutes];
                            }
                        }
                        
                    }
                    else {
                        message = [NSString stringWithFormat:prefix , minutes, @"min"];
                    }
                    
                }
                else {
                    // lock date is several seconds away
                    breakdownInfo = [sysCalendar components:NSSecondCalendarUnit fromDate: now toDate:referenceDate options:0];
                    if ([breakdownInfo second] > 1) {
                        message = [NSString stringWithFormat:prefix, [breakdownInfo second], @"sek"];
                    }
                    else {
                        message = [NSString stringWithFormat:prefix, 1, @"sek"];
                        
                        // trigger an update of the timeline and reload the main view
                        // (because this round will be closed
                        [NSTimer scheduledTimerWithTimeInterval:2.0
                                                         target:self
                                                       selector:@selector(refreshRound)
                                                       userInfo:nil
                                                        repeats:NO];
                        
                        
                    }
                }
            }
        }
    }
    else {
        message = @"Omgången är stängd";
    }
    
    self.label.text = message;
}

- (void) refreshRound {
    [self.overviewViewController.timelineScrollView refreshSections];
    [self.overviewViewController.timelineScrollView selectTournamentRound:self.overviewViewController.timelineScrollView.currentRound];
}

@end
