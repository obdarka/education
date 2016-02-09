//
//  HYTimerView.m
//  heyya
//
//  Created by Daria Kovalenko on 2/5/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import "HYTimerLabel.h"
#import "HYTimerModel.h"

static const NSInteger HYTimerAlertTime = 600;
static const NSInteger HYTimerLifeTime = 3600;

@interface HYTimerLabel ()

- (void)initialize;
- (void)updateAfterBackgound;

@end

@implementation HYTimerLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

#pragma mark
- (void)initialize {
    self.timerModel = [HYTimerModel new];
    self.timerModel.delegate = self;
    self.creationTime = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAfterBackgound)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - Setters
- (void)setSecondsLeft:(NSInteger)secondsLeft {
    self.timerModel.secondsLeft = secondsLeft;
}

#pragma mark - Launch timer method
- (void)launchWithCreationTime:(NSDate *)creationTime {
    NSTimeInterval secondsLeft = (HYTimerLifeTime - [[NSDate date] timeIntervalSinceDate:creationTime]);
    self.timerModel.secondsLeft = secondsLeft;
    self.timerModel.timeInterval = 1.0;
    [self.timerModel launchTimer];
}

- (void)stopTimer {
    [self.timerModel stopTimer];
}

#pragma mark - Handle updates after app notifications
- (void)updateAfterBackgound {
    if (self.creationTime) {
        [self setSecondsLeft:(HYTimerLifeTime - [[NSDate date] timeIntervalSinceDate:_creationTime])];
    }
}

#pragma mark - Timer methods
- (void)launchTimer {
    self.timerModel.timeInterval = 1.0;
    [self.timerModel launchTimer];
}

#pragma mark - TimerModel delegate method
- (void)timerModel:(HYTimerModel *)timerModel didUpdateTimerWithSeconds:(NSTimeInterval)secondsLeft {
    NSString *timerText = @"";
    if (secondsLeft > 0) {
        NSInteger minutes = secondsLeft / 60;
        NSInteger seconds = secondsLeft - minutes * 60;
        timerText = [timerText stringByAppendingFormat:(minutes > 9) ? @"%ld:" : @"0%ld:", (long)minutes];
        timerText = [timerText stringByAppendingFormat:(seconds > 9) ? @"%ld" : @"0%ld", (long)seconds];
    } else {
        timerText = @"00:00";
    }
    self.text = timerText;
    [self updateTimerColorWithSeconds:secondsLeft];
}

#pragma mark - UI
- (void)updateTimerColorWithSeconds:(NSTimeInterval)seconds {
    if (seconds == HYTimerLifeTime) {
        self.textColor = [HYTimerLabel defailtTimerColor];
    } else {
        self.textColor = seconds < HYTimerAlertTime ? [HYTimerLabel expireTimerColor] : [HYTimerLabel runningTimerColor];
    }
}

#pragma mark - Timer colors
+ (UIColor *)defailtTimerColor {
    return [UIColor colorWithRed:0. green:0. blue:0.0 alpha:0.54];
}

+ (UIColor *)runningTimerColor {
    return [UIColor colorWithRed:52./255. green:216.0/255. blue:41./255. alpha:1.0];
}

+ (UIColor *)expireTimerColor {
    return [UIColor colorWithRed:226./255. green:102./255. blue:66./255. alpha:1.0];
}

@end
