//
//  BabyActivity+CoreDataProperties.swift
//  babyMonitor
//
//  Created by zjw on 11/11/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BabyActivity {

    @NSManaged var activityName: String?
    @NSManaged var date: NSDate?
    @NSManaged var icon: String?
    @NSManaged var type: String?
    @NSManaged var state: NSNumber?

}
