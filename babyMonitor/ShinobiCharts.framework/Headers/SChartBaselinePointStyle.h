//
//  SChartBaselinePointStyle.h
//  ShinobiCharts
//
//  Copyright (c) 2014 Scott Logic Ltd. All rights reserved.
//
//

#import "SChartBasePointStyle.h"

NS_ASSUME_NONNULL_BEGIN

/** `SChartBaselinePointStyle` manages the appearance of data points within chart series that contain a baseline property.
 
 This point style class is subclassed by `SChartPointStyle`.
 
 @available Standard
 @available Premium
 */
@interface SChartBaselinePointStyle : SChartBasePointStyle

#pragma mark -
#pragma mark Styling Properties
/** @name Styling Properties */

/** The color of the data points when the chart series goes below its baseline. */
@property (nonatomic, strong, nullable)     UIColor   *colorBelowBaseline;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartBaselinePointStyle *)style;

@end

NS_ASSUME_NONNULL_END
