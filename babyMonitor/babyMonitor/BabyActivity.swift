//
//  BabyActivity.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BabyActivity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func initByType()->BabyActivity{
        let babyName = "Kevin "
        self.date = NSDate()
        switch self.type!{
        case BabyActityType.CRY.rawValue:
            self.activityName = babyName + "cried"
            return self
        case BabyActityType.WET.rawValue:
            self.activityName = babyName + "peed"
            return self
        case BabyActityType.COLD.rawValue:
            self.activityName = babyName + "kicked off quilt"
            return self
        case BabyActityType.OUTOFSIGHT.rawValue:
            self.activityName = babyName + "out of sight"
            return self
        case BabyActityType.START.rawValue:
            let dateTxt = getDateText(self.date!)
            self.activityName = "Monitor started on " + dateTxt
            return self
        default:
            self.activityName = "Error"
            return self
        }
    }
    
    func getIconForActivity()->UIImage{
        switch self.type!{
        case BabyActityType.CRY.rawValue:
            return UIImage(named:"Crying")!
        case BabyActityType.WET.rawValue:
            return UIImage(named: "Nappy")!
        case BabyActityType.COLD.rawValue:
            return UIImage(named: "Cold")!
        case BabyActityType.START.rawValue:
            return UIImage(named: "Start")!
        case BabyActityType.OUTOFSIGHT.rawValue:
            return UIImage(named:"Footprints")!
        default:
            return UIImage(named:"Start")!
        }
    }
    
    func getDateText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter.stringFromDate(date)
    }
}
