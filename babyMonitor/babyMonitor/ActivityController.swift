//
//  ActivityController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData


enum BabyActityType : String {
        case CRY, WET, COLD, START, END
    }
class ActivityController: UITableViewController {
    
    var managedObjectContext : NSManagedObjectContext?
    
    // the activity list that is being displayed
    var babyActivities: [BabyActivity]!
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        // test: new BabyActivity object
        let activity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        activity.type = BabyActityType.CRY.rawValue
        activity.initByType()
        
        let activity2 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        activity2.type = BabyActityType.WET.rawValue
        activity2.initByType()
        
        let activity3 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        activity3.type = BabyActityType.COLD.rawValue
        activity3.initByType()

        
        let activity0 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        activity0.type = BabyActityType.START.rawValue
        activity0.initByType()
        
        
        babyActivities.append(activity0)
        babyActivities.append(activity)
        babyActivities.append(activity2)
        babyActivities.append(activity3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // Fetch current dataset
    func fetchData(){
        // Declare fetch entityName
        let fetch = NSFetchRequest(entityName: "BabyActivity")
        // Declare the sort approach, sort by priority in ascending order
        let prioritySort  = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [prioritySort]
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetch) as! [BabyActivity]
            // Initialise the categoryList using fetch results
            babyActivities = fetchResults
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Number of monitors is the section number in this tableView
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of activities is the rows number in the section
        return babyActivities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath) as! ActivityLogCell
        let babyActivity = babyActivities[babyActivities.count - 1 - indexPath.row]
        activityCell.time.text = String(babyActivity.date)
        activityCell.activityName.text = babyActivity.activityName
        activityCell.icon.image =  babyActivity.getIconForActivity()
        activityCell.time.text = getTimeText(babyActivity.date!)
        activityCell.selectionStyle = UITableViewCellSelectionStyle.None
        return activityCell
    }
    
    
    // Get time in a format text
    func getTimeText(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }
    
    // set the height of cell.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
