//
//  SChartRedrawCalculator
//  SChart
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiChart;
@class SChartSeries;

/**
 *  Classes conforming to this protocol control the queueing of calls to redraw the chart.
 */
@protocol SChartRedrawCalculator <NSObject>

/**
 *  This method is responsible for determining whether `chart` should be redrawn in order to complete
 *  any in-progress animations.
 *
 *  @param chart           The chart on which animations should be queued, if necessary
 *  @param animationActive Whether an animation is in-progress on at least one of the series on the chart.
 * 
 *  @return A boolean, indicating whether a call to redraw the chart should be made.
 */
- (BOOL)shouldQueueRedrawForAnimationOnChart:(ShinobiChart *)chart
                             animationActive:(BOOL)animationActive;

@end
