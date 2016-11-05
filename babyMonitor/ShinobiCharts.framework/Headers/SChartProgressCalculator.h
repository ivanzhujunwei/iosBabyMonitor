//
//  SChartProgressCalculator.h
//  ShinobiCharts
//

/**
 *  Provides an interface for any object wishing to calculate a `progress` value.
 */
@protocol SChartProgressCalculator

/**
 * The current progress value.
 *
 * Returns a progress value between 0 and 1, inclusive.
 * A value of 1 or greater indicates completion.
 *
 * @return A double representing the current progress value.
 */
-(double)progress;

/** Reset the calculator for re-use.
 *
 * Any state in the progress calculator is reset, and the calculator acts as if
 * it's starting again from its initial state, i.e. a progress of zero.
 */
-(void)resetForReuse;

/**
 * Returns YES when the progress calculator's progress is > 1
 */
- (BOOL)isComplete;

@end
