//
//  SChartRedrawCalculatorFeedbackLoop
//  SChart
//
//  Copyright 2016 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SChartRedrawCalculator.h"

/**
 *  Ensures the chart is redrawn if an animation is currently in progress.
 */
@interface SChartRedrawCalculatorFeedbackLoop : NSObject <SChartRedrawCalculator>
@end
