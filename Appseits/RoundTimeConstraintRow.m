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
        self.label.textColor = [UIColor whiteColor];
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
    if (self.round.open) {
        NSDate *now = [NSDate date];
        
        // Get conversion to months, days, hours, minutes
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        NSDateComponents *breakdownInfo = [sysCalendar components:NSMonthCalendarUnit fromDate:now  toDate:self.round.lockDate options:0];
        
        if ([breakdownInfo month] > 1) {
            // lock date is several months away
            message = [NSString stringWithFormat:@"Omgången låses om %i månader", [breakdownInfo month]];
        }
        else {
            // lock date is several days away
            breakdownInfo = [sysCalendar components:NSDayCalendarUnit fromDate:now  toDate:self.round.lockDate options:0];
            if ([breakdownInfo day] > 1) {
                message = [NSString stringWithFormat:@"Omgången låses om %i dagar", [breakdownInfo day]];
            }
            else {
                // lock date is several hours or minutes away
                breakdownInfo = [sysCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate: now toDate:self.round.lockDate options:0];
                
                int hours = [breakdownInfo hour];
                int minutes = [breakdownInfo minute];
                
                if (hours > 0 || minutes > 0) {
                    
                    if (hours > 0) {
                        // timmar 
                        if (hours == 1) {
                            message = @"Omgången låses om en timme";
                        }
                        else {
                            message = [NSString stringWithFormat:@"Omgången låses om %i timmar", [breakdownInfo hour]];
                        }
                        // och minuter
                        if (minutes > 0) {
                            if (minutes == 1) {
                                message = [NSString stringWithFormat:@"%@ och en minut", message];
                            }
                            else {
                                message = [NSString stringWithFormat:@"%@ och %i minuter", message, minutes];
                            }
                        }
                        
                    }
                    else {
                        if (minutes == 1) {
                            message = @"Omgången låses om en minut";
                        }
                        else {
                            message = [NSString stringWithFormat:@"Omgången låses om %i minuter", minutes];
                        }
                    }
                    
                }
                else {
                    // lock date is several seconds away
                    breakdownInfo = [sysCalendar components:NSSecondCalendarUnit fromDate: now toDate:self.round.lockDate options:0];
                    if ([breakdownInfo second] > 1) {
                        message = [NSString stringWithFormat:@"Omgången låses om %i sekunder", [breakdownInfo second]];
                    }
                    else {
                        message = @"Omgången låses om en sekund";
                        
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
