//
//  UtilityForViewControllers.swift
//  babyMonitor
//
//  Created by zjw on 31/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit

// This controller provides some basic utility tools for the application
extension UIViewController {
    
    
    // Returns the amount of minutes from another date
    func minutesFrom(date: NSDate) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: currentDate, options: []).minute
    }
    
    // Returns the amount of days from another date
    func daysFrom(date: NSDate) -> Int{
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: currentDate, options: []).day
    }
    
    // Returns the amount of hours from another date
    func hoursFrom(date: NSDate) -> Int{
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: currentDate, options: []).hour
    }
    
    // Return the amount of hours from oldDate to newDate
    func minutesFromTwoDate(oldDate: NSDate, newDate: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: oldDate, toDate: newDate, options: []).minute
    }
    
    // Get date in text format
    func getDateText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    // Get date in text format
    func getDateShortText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

struct Constants {
    // Temperature sensor server location
    static let temperatureUrl = "http://172.20.10.5:8088/"
    static let cameraUrl = "http://172.20.10.5/cameravideo.php"
    static let mositureUrl = "http://172.20.10.2:8087/"
    static let soundUrl = "http://172.20.10.5:8001/"
    
    static let cameraHideUrl = "http://172.20.10.5/cam.jpg"
}
