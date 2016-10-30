//
//  Settings+CoreDataProperties.swift
//  babyMonitor
//
//  Created by zjw on 30/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Settings {

    @NSManaged var babyCryOn: NSNumber?
    @NSManaged var babyCryVolume: NSNumber?
    @NSManaged var diaperWetOn: NSNumber?
    @NSManaged var monitor: NSNumber?
    @NSManaged var tempAnomaly: NSNumber?
    @NSManaged var useDefaultHomePage: NSNumber?
    @NSManaged var homePagePhoto: NSData?

}
