//
//  SChartCrosshairStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Styling properties for the cross hair object SChartCrosshair
 
 */
@interface SChartCrosshairStyle : NSObject <NSCopying>
/** @name Styling Properties */
/** The width of the lines from the target to the axes */
@property (nonatomic, strong, nullable)       NSNumber    *lineWidth;
/** The color of the lines from the target to the axes */
@property (nonatomic, strong, nullable)       UIColor     *lineColor;
/** The font of the text in the tooltip */
@property (nonatomic, strong, nullable)       UIFont      *defaultFont;
/** The color of the text in the tooltip */
@property (nonatomic, strong, nullable)       UIColor     *defaultTextColor;
/** The background color of the labels in the tooltip */
@property (nonatomic, strong, nullable)       UIColor     *defaultLabelBackgroundColor;
/** The background color of the tooltip */
@property (nonatomic, strong, nullable)       UIColor     *defaultBackgroundColor;
/** The corner radius of the tooltip */
@property (nonatomic, strong, nullable)       NSNumber    *defaultCornerRadius;
/** The width of the tooltip border */
@property (nonatomic, strong, nullable)       NSNumber    *defaultBorderWidth;
/** The color of the tooltip border */
@property (nonatomic, strong, nullable)       UIColor     *defaultBorderColor;
/** The number of key-value pairs displayed on each row of multi-value tooltips. 
 
 @warning *Important* This property will be used internally by calling `intValue`.*/
@property (nonatomic, retain)       NSNumber    *defaultKeyValuesPerRow;


/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
- (void)supplementStyleFromStyle:(SChartCrosshairStyle *)style;

@end

NS_ASSUME_NONNULL_END

