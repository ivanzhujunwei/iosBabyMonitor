//
//  SChartAnimationTracker.h
//  ShinobiCharts
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@class SChartSeries, SChartAnimation, SChartAnimationState;
@protocol SChartProgressCalculator;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SChartCompletionBlock)(BOOL finished);

/** Informs the chart about which series it should show or hide using the corresponding animation.
 */
@interface SChartAnimationTracker : NSObject

#pragma mark - Animation
/** @name Animation */

/** Shows a hidden series with the supplied animation using the progress value determined by the progress calculator.
 
 @param series A series to animate.
 @param animation An animation to display the currently displayed series. If this is nil, the series will show immediately.
 @param completion A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called.
  @param progressCalculator The progress calculator used in conjunction with the animation instance to show the series.
 */
-(void)showSeries:(SChartSeries *)series
        animation:(nullable SChartAnimation *)animation
progressCalculator:(id<SChartProgressCalculator>)progressCalculator
       completion:(nullable SChartCompletionBlock)completion;

/**
 *  Shows a hidden series with the supplied animation lasting for the time specified by the value of 'duration'.
 *
 *  @param series     A series to animate.
 *  @param animation  An animation to display the currently displayed series.
 *  @param duration   The duration of the animation.
 *  @param completion A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called.
 */
- (void)showSeries:(SChartSeries *)series
         animation:(SChartAnimation *)animation
          duration:(double)duration
        completion:(nullable SChartCompletionBlock)completion;

/** Hides a currently displayed series with the supplied animation using the progress value determined by the progress calculator.
 
 @param series A series to animate.
 @param animation An animation to display the currently hidden series. If this is nil, the series will hide immediately.
 @param completion A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called.
 @param progressCalculator The progress calculator used in conjunction with the animation instance to hide the series.
 */
-(void)hideSeries:(SChartSeries *)series
        animation:(nullable SChartAnimation *)animation
progressCalculator:(id<SChartProgressCalculator>)progressCalculator
       completion:(nullable SChartCompletionBlock)completion;

/**
 *  Hides a currently displayed series with the supplied animation lasting for the time specified by the value of 'duration'.
 *
 *  @param series     A series to animate.
 *  @param animation  An animation to hide the currently displayed series.
 *  @param duration   The duration of the animation.
 *  @param completion A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called.
 */
- (void)hideSeries:(SChartSeries *)series
         animation:(SChartAnimation *)animation
          duration:(double)duration
        completion:(nullable SChartCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
