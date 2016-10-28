//
//  Settings+CoreDataProperties.swift
//  babyMonitor
//
//  Created by zjw on 29/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Settings {

    @NSManaged var monitor: NSNumber?
    @NSManaged var babyCryOn: NSNumber?
    @NSManaged var diaperWetOn: NSNumber?
    @NSManaged var tempAnomaly: NSNumber?
    @NSManaged var babyCryVolume: NSNumber?

}
