//
//  SChartSeries+Deprecated.h
//  ShinobiCharts
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//

#import "SChartSeries.h"

@interface SChartSeries ()

#pragma mark -
#pragma mark Animation
/* @name Animation */

/* Whether entry and exit animations are enabled for this series.
 
 If this is set to `YES`, the series will animate in and out using its entryAnimation and exitAnimation animation properties.
 If this is set to `NO`, the series will appear and disappear instantly, with no animation.
 By default, this property is set to `NO` - animation disabled.
 
 @warning Currently, animation is not supported on radial series (SChartRadialLineSeries).
 */
@property (nonatomic)           BOOL    animationEnabled SCHART_DEPRECATED("Use the chart's `animationTracker` method `showSeries:animation:completion:` instead.");

/* The animation which describes how the series will enter the chart.
 
 The chart series will enter when the chart is first drawn, or when its `hidden` property is set to `NO` (having previously been `YES`).
 See `SChartAnimation` for more details.
 */
@property (retain, nonatomic) SChartAnimation *entryAnimation SCHART_DEPRECATED("Use the chart's `animationTracker` method `showSeries:animation:completion:` instead.");

/* The animation which describes how the series will exit the chart.
 
 The chart series will exit the chart when its `hidden` property is set to `YES` (having previously been `NO`).
 See `SChartAnimation` for more details.
 */
@property (retain, nonatomic) SChartAnimation *exitAnimation SCHART_DEPRECATED("Use the chart's `animationTracker` method `hideSeries:animation:completion:` instead.");

@end
