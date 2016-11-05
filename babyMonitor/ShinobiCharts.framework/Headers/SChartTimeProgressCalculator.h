//
//  SChartTimeAnimator.h
//  ShinobiCharts
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartProgressCalculator.h"

NS_ASSUME_NONNULL_BEGIN

/** Calculates a progress value based on time.
 
 It uses the `duration` time value its initialised with to calculate a progress value.
 The calculator records a start time when we call the `progress` method for first time and will produce a progress value of 0 at this point.
 The progress value will be 1 when the current time equals the start time the calculator recorded + the duration.
 */
@interface SChartTimeProgressCalculator : NSObject <SChartProgressCalculator, NSCopying>

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/** Constructs a time calculator with a duration.
 
 @param duration The time in seconds from the start time when the progress value equals 1.
 @return A progress calculator based on time.
 */
-(instancetype)initWithDuration:(double)duration NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
