//
//  HYTimerModel.m
//
//
//  Created by Daria Kovalenko on 2/8/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import "HYTimerModel.h"
#import <QuartzCore/QuartzCore.h>

@interface HYTimerModel ()
@property (nonatomic) NSTimeInterval timestamp;

- (void)launchTimerWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)updateWithTimer:(NSTimer *)timer;
- (void)updateSecondsLeft;
- (void)launchNextTimer;

@end

@implementation HYTimerModel

- (void)dealloc {
    [self stopTimer];
}

#pragma mark - Setters
- (void)setSecondsLeft:(NSInteger)secondsLeft {
    _secondsLeft = secondsLeft;
    [self updateSecondsLeft];
}


#pragma mark - Timer launching
- (void)launchTimer {
    self.timestamp = CACurrentMediaTime();
    [self launchTimerWithTimeInterval:self.timeInterval];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)launchTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(updateWithTimer:)
                                                userInfo:nil
                                                 repeats:NO];
}

#pragma mark - Timer action
- (void)updateWithTimer:(NSTimer *)timer {
    [self updateSecondsLeft];
    [self launchNextTimer];
}

- (void)updateSecondsLeft {
    double seconds = _secondsLeft;
    if (self.delegate) {
        [self.delegate timerModel:self didUpdateTimerWithSeconds:seconds];
    }
    seconds--;
    _secondsLeft = seconds;
}

- (void)launchNextTimer {
    NSTimeInterval newTimestamp = CACurrentMediaTime();
    NSTimeInterval timeInterval = self.timeInterval * 2 - (newTimestamp - self.timestamp);
    self.timestamp = newTimestamp;
    [self launchTimerWithTimeInterval:timeInterval];
}

@end
