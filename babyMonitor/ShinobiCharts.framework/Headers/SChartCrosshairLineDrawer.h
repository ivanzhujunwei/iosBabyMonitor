//
//  SChartCrosshairLineDrawer.h
//  ShinobiCharts
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SChartMappedSeries;
@class SChartCanvas;
@class SChartAxis;

@protocol SChartCrosshairLineDrawer <NSObject>

/** Responsible for creating a UIBezierPath for the lines of the crosshair.
 
 @param plotAreaFrame The frame of the plot area.
 @param series The series being tracked by the crosshair.
 @param trackedDataPointCenter The center of the tracked data point.
 @param xAxis The x-axis associated with the series.
 @param yAxis The y-axis associated with the series.
 */
-(UIBezierPath*)drawLinesForCrosshair:(CGRect)plotAreaFrame
                               series:(SChartMappedSeries*)series
               trackedDataPointCenter:(CGPoint)trackedDataPointCenter
                                xAxis:(SChartAxis*)xAxis
                                yAxis:(SChartAxis*)yAxis;

/** Responsible for creating a UIBezierPath for the ellipses of the crosshair.
 
 @param trackedDataPointCenter The center of the tracked data point.
 */
-(UIBezierPath*)drawEllipseForCrosshair:(CGPoint)trackedDataPointCenter;

@end

NS_ASSUME_NONNULL_END
