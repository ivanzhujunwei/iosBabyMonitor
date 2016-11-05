//
//  SChartAxis+Deprecated.h
//  ShinobiCharts
//
//  Created by Andrew Polkinghorn on 28/05/2014.
//
//

#import "SChartAxis.h"

@class SChartMappedSeries;
@class SChartBarColumnSeries;

@interface SChartAxis ()


/* The current _displayed_  range of the axis.
 
 This property is the actual range currently displayed on the visible area of the chart- which may not be the range that was explicitly set. The axis may make small adjustments to the range to make sure that whole bars are displayed etc. This is a `readonly` property - explicit requests to change the axis range should be made through the method `setRangeWithMinimum:andMaximum:`
 
 @see SChartRange
 @see SChartNumberRange
 @see SChartDateRange */
@property (nonatomic, retain, readonly) SChartRange *axisRange DEPRECATED_MSG_ATTRIBUTE("use 'range' instead");

@end
