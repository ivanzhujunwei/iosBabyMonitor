//
//  Monitor+CoreDataProperties.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Monitor {

    @NSManaged var date: NSDate?
    @NSManaged var title: String?
    @NSManaged var babyActivities: NSSet?

}
