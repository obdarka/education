//
//  HYTimerView.h
//  
//
//  Created by Daria Kovalenko on 2/5/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTimerModel.h"

@interface HYTimerLabel : UILabel <HYTimerModelDelegate>
@property (nonatomic, strong) NSDate *creationTime;
@property (nonatomic, strong) HYTimerModel *timerModel;

+ (UIColor *)defailtTimerColor;
+ (UIColor *)runningTimerColor;
+ (UIColor *)expireTimerColor;

- (void)updateTimerColorWithSeconds:(NSTimeInterval)seconds;

- (void)launchWithCreationTime:(NSDate *)creationTime;
- (void)stopTimer;
- (void)setSecondsLeft:(NSInteger)secondsLeft;

@end
