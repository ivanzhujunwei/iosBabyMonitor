//
//  SChartTickMark+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartTickMark.h"

@interface SChartTickMark ()

/* Create a tick mark with a particular label. */
- (id)initWithLabel:(CGRect)labelFrame
            andText:(NSString *)text
DEPRECATED_MSG_ATTRIBUTE("Use 'init'");

@end
