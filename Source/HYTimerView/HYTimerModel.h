//
//  HYTimerModel.h
//  
//
//  Created by Daria Kovalenko on 2/8/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYTimerModel;
@protocol HYTimerModelDelegate <NSObject>

- (void)timerModel:(HYTimerModel *)timerModel didUpdateTimerWithSeconds:(NSTimeInterval)seconds;

@end

@interface HYTimerModel : NSObject
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id <HYTimerModelDelegate> delegate;
@property (nonatomic) NSInteger secondsLeft;
@property (nonatomic) NSTimeInterval timeInterval;

- (void)launchTimer;
- (void)stopTimer;

@end
