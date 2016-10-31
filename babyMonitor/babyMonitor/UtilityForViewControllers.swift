//
//  UtilityForViewControllers.swift
//  babyMonitor
//
//  Created by zjw on 31/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Returns the amount of minutes from another date
    func minutesFrom(date: NSDate) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: currentDate, options: []).minute
    }
    
    // Returns the amount of days from another date
    func daysFrom(date: NSDate) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: currentDate, options: []).day
    }
    
    // Returns the amount of hours from another date
    func hoursFrom(date: NSDate) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: currentDate, options: []).hour
    }
    
    // Get date in text format
    func getDateText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
}
