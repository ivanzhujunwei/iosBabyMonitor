//
//  SChartOHLCSeriesStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartBarColumnSeriesStyle.h"

NS_ASSUME_NONNULL_BEGIN

/** `SChartOHLCSeriesStyle` manages the appearance of an instance of `SChartOHLCSeries` on the chart.
 
 Each data point in an OHLC series is visualised as a line between the high and low values, with short perpendicular bars indicating the open and close positions.
 
 The colors used to represent each data point are different dependent on whether the data value is rising or falling.  You can set the colors for both cases in this class.  A gradient is applied to the colors in each data point, going from top to bottom if the series is horizontal, and from left to right if the series is vertical.  See `risingColor`, `fallingColor`, `risingColorGradient` or `fallingColorGradient` for more information.
 
 @available Premium
 @sample FinancialChart
 */
@interface SChartOHLCSeriesStyle : SChartSeriesStyle <NSCopying>

/** @name Styling properties */

/** The color of the body of the OHLC point if the point is rising. */
@property (nonatomic, strong, nullable)       UIColor     *risingColor;

/** The gradient color of the body of the OHLC point if the point is rising. */
@property (nonatomic, strong, nullable)       UIColor     *risingColorGradient;

/** The color of the body of the OHLC point if the point is falling. */
@property (nonatomic, strong, nullable)       UIColor     *fallingColor;

/** The gradient color of the body of the OHLC point if the point is falling. */
@property (nonatomic, strong, nullable)       UIColor     *fallingColorGradient;

/** The width of the trunk of the OHLC point, in points. */
@property (nonatomic, strong, nullable)     NSNumber  *trunkWidth;

/** The width of the arms of the OHLC point, in points. */
@property (nonatomic, strong, nullable)     NSNumber  *armWidth;

/** Updates this style object using the specified style.
 @param style The new style with which to update this style object. */
-(void)supplementStyleFromStyle:(SChartOHLCSeriesStyle *)style;

@end

NS_ASSUME_NONNULL_END


