//
//  SChartPointSeriesStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2013 Scott Logic Ltd. All rights reserved.
//
//

#import "SChartSeriesStyle.h"

@class SChartBaselinePointStyle;

NS_ASSUME_NONNULL_BEGIN

@interface SChartPointSeriesStyle : SChartSeriesStyle {
    @protected
    SChartBaselinePointStyle *_pointStyle;
    SChartBaselinePointStyle *_selectedPointStyle;
}

/** @name Style Properties */
/** The style of points that are not selected
 
 @warning The class type of the point style has changed from `SChartBasePointStyle` to `SChartBaselinePointStyle`.
 */
- (SChartBaselinePointStyle* _Nullable) pointStyle;
- (void) setPointStyle:(SChartBaselinePointStyle *)pointStyle;

/** The style of points that are selected
 
 @warning The class type of the point style has changed from `SChartBasePointStyle` to `SChartBaselinePointStyle`.
 */
- (SChartBaselinePointStyle* _Nullable) selectedPointStyle;
- (void) setSelectedPointStyle:(SChartBaselinePointStyle *) selectedPointStyle;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartPointSeriesStyle *)style;

@end

NS_ASSUME_NONNULL_END

