//
//  ShinobiCharts.h
//  ShinobiCharts
//
//

#import <Foundation/Foundation.h>
#import "ShinobiChart.h"

@class SChartTheme;

NS_ASSUME_NONNULL_BEGIN

/** A utility class which allows you to set themes and licenseKeys for all the ShinobiCharts in your app, rather than having to configure each independently.
 
 This is best done early on, before any charts are created.

 @sa ChartsUserGuide
 
 @available Standard
 @available Premium
 */
@interface ShinobiCharts : NSObject

/* Set a licenseKey for all ShinobiCharts in your app.
 */
+ (void)setLicenseKey:(NSString *)key;

/** The licenseKey set for all ShinobiCharts in your app.
 */
+ (NSString *)licenseKey;

/* Set a theme for all ShinobiCharts in your app.
 
 @sa SChartTheme
 */
+ (void)setTheme:(nullable SChartTheme *)theme DEPRECATED_MSG_ATTRIBUTE("Initialize the chart with a theme using 'initWithChart:withTheme:'");

/* The theme set for all ShinobiCharts in your app.
 
 @sa SChartTheme
 */
+ (nullable SChartTheme *)theme DEPRECATED_ATTRIBUTE;

/** Returns a string describing the version of the Charts framework being used.
 
 This includes a version number, the type of framework (Premium, Standard, or Trial) and the date upon which the version was released.
*/
+(NSString *)getInfo;

@end

NS_ASSUME_NONNULL_END

