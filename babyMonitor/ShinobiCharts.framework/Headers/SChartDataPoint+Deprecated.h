//
//  SChartDataPoint+Deprecated.h
//  ShinobiCharts
//
//  Created by Andrew Polkinghorn on 14/04/2016.
//
//

@interface SChartDataPoint ()

#pragma mark - Selection

/* Defines whether this point is selected.
 
 When set to `YES` this data point will adopt a selected state. One effect of setting this property is that the style of the data point will change.  The series will apply the selected style to this point, as opposed to the normal style.
 
 NOTE: When altering this property's value after the chart has been rendered, you'll need to explicitly call the `redrawChart` method on the chart responsible for displaying the data point.
 */
@property (nonatomic, assign) BOOL selected SCHART_DEPRECATED("Use `selectedDataPoints` on `SChartSeries` instead.");

@end
