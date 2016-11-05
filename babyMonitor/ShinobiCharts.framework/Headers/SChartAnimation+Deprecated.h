//
//  SChartAnimation+Deprecated.h
//  ShinobiCharts
//
//  Created by Andrew Polkinghorn on 19/04/2016.
//
//

@interface SChartAnimation ()

/* The duration of the animation.
 
 The time taken, in seconds, for the animation to progress from start to finish.
 The duration of the animations returned by the factory methods provided is 2.4 seconds.
 The duration of an animation created via alloc/init is 1/64 seconds (instant).
 Use this property to configure how long an animation should take to complete.
 */
@property (nonatomic, strong) NSNumber *duration SCHART_DEPRECATED("Use the `duration` property on the `SChartTimeAnimationProgressCalculator` class.");

@end
