//
//  SChartStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** A look of a chart is managed by an instance of `SChartTheme` or one of its sub-classes.  Themes contain a set of style objects, each of which are responsible for managing the look of a particular aspect of the chart.
 
 The SChartStyle class is responsible for managing the overall look of the chart.  This includes things like:
 
 - The background color of the chart.
 - The color and width of the chart border.
 - The background color of the chart plot area.
 - The color and width of the chart plot area border.
 
 More information about using SChartStyle can be found in the [user guide](../../user_guide.html#Styles).
 
 @available Standard
 @available Premium
 */
@interface SChartStyle : NSObject <NSCopying>

/** @name Styling Properties */
/** The background color of the chart. 
 
 @see backgroundColorGradient
 */
@property (nonatomic, strong, nullable)     UIColor  *backgroundColor;

/** The secondary background color of the chart.  
 
 This is used when the chart background has a gradient between two colors.  The gradient runs from backgroundColor to backgroundColorGradient.
 
 @see backgroundColor
 */
@property (nonatomic, strong, nullable)     UIColor  *backgroundColorGradient;

/** The border color of the chart. 
 
 The chart border runs around the edge of the chart canvas.  This includes the plot area and the chart axes.
 */
@property (nonatomic, strong, nullable)     UIColor  *borderColor;

/** The width of the chart border, in points. 
 
 The chart border runs around the edge of the chart canvas.  This includes the plot area and the chart axes.
 */
@property (nonatomic, strong, nullable)     NSNumber *borderWidth;

/** The background color of the chart plot area.
 
 The plot area is the region of the chart which is bounded by the chart axes.
 */
@property (nonatomic, strong, nullable)     UIColor  *plotAreaBackgroundColor;

/** The border color of the chart plot area.
 
 The plot area is the region of the chart which is bounded by the chart axes.
 */
@property (nonatomic, strong, nullable)     UIColor  *plotAreaBorderColor;

/** The line width for the border of the chart plot area, in points.
 
 The plot area is the region of the chart which is bounded by the axes.
 */
@property (nonatomic, strong, nullable)     NSNumber *plotAreaBorderWidth;

/** The background color of the chart canvas area.
 
 The canvas area includes the chart plot area and the chart axes.
 */
@property (nonatomic, strong, nullable)     UIColor  *canvasBackgroundColor;

/** The color of the indicator which is displayed when data is loaded in the background. */
@property (nonatomic, strong, nullable)     UIColor  *loadingDataIndicatorColor;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartStyle *)style;

@end

NS_ASSUME_NONNULL_END
