//
//  HomeController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData
import CoreImage

//
class HomeController: UIViewController {

    @IBOutlet var babyPhone: UIImageView!
    
    // lastest updated temperature
    @IBOutlet var latestUpdateTemp: UILabel!
    
    @IBOutlet var lastActivityLabel: UILabel!
    
    var managedObjectContext : NSManagedObjectContext?
    
    var settings:Settings?
    
//    var timer:NSTimer!
    
    // the activity list that is being displayed
    var babyActivities: [BabyActivity]!
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        let activityController = self.tabBarController?.viewControllers![1].childViewControllers[0] as! ActivityController
        activityController.scheduleJobReadSensor()
        // set home page photo
        //let image = UIImage(data: (settings?.homePagePhoto)!)
        //babyPhone.image = image
        babyPhone.image = UIImage(named: "baby_smile")
        // temperature text
        
        // set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.translucent = true
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetTemp), name: "changeTemperature", object: nil)
    }
    
    // MARK: Timely job to read sensors
//    func scheduleJobReadSensor(){
//        if Bool(settings!.monitor!) {
//            timer = NSTimer.scheduledTimerWithTimeInterval(Double(settings!.timePeriod!), target: self, selector: #selector(ActivityController.readSensors), userInfo: nil, repeats: true)
//        }
//    }
    
//    // Reset all the settings
//    func resetSettings(notification: NSNotification){
//        settings = notification.object as? Settings
//        // Reset the timer
//        if timer != nil {
//            timer.invalidate()
//            timer = nil
//        }
//        scheduleJobReadSensor()
//    }
    
    override func viewWillAppear(animated: Bool) {
        fetchData()
        
        if (settings?.homePagePhoto == nil)
        {
            babyPhone.image = UIImage(named: "baby_smile")
        }
        else
        {
            let image = UIImage(data: (settings?.homePagePhoto)!)
            babyPhone.image = image
        }
        
        // TODO: FROM SENSOR
        if settings?.temperature ==  nil{
            latestUpdateTemp.text =  ""
            print("Have not read the temperature yet")
        }else{
            latestUpdateTemp.text =  "\(settings!.temperature!)°C"
        }
        latestUpdateTemp.textColor = themeColor
        
        // Get latest activity
        if babyActivities.count > 0 {
            lastActivityLabel.textColor = themeColor
            lastActivityLabel.font = UIFont.boldSystemFontOfSize(17.0)
            let activity = babyActivities[babyActivities.count - 1]
            let miniAgo = minutesFrom(activity.date!)
            let hourAgo = hoursFrom(activity.date!)
            let dayAgo = daysFrom(activity.date!)
            let activityName = (settings!.babyName )! + " " + activity.activityName!
            if miniAgo <= 1 {
                lastActivityLabel.text = "\(activityName) just now."
                return
            }else if hourAgo < 1 {
                // Within an hour
                lastActivityLabel.text = "\(miniAgo) miniutes ago, \(activityName)"
                return
            }else if dayAgo < 1 {
                lastActivityLabel.text = "\(hourAgo) hours ago, \(activityName)"
                return
            }else if dayAgo < 7 {
                lastActivityLabel.text = "\(dayAgo) days ago, \(activityName)"
                return
            }else {
                lastActivityLabel.text = "Have not monitored your baby for a long time"
                return
            }
        }
    }
    
    // Reset the latest temperature
    func resetTemp(){
    }
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fetch data from core data
    func fetchData(){
        // Declare fetch entityName
        let fetchSettings = NSFetchRequest(entityName: "Settings")
        let fetchActivities = NSFetchRequest(entityName: "BabyActivity")
        // Declare the sort approach, sort by priority in ascending order
        let prioritySort  = NSSortDescriptor(key: "date", ascending: true)
        fetchActivities.sortDescriptors = [prioritySort]
        do{
            // Fetch request
            let fetchActivityResults = try managedObjectContext!.executeFetchRequest(fetchActivities) as! [BabyActivity]
            // Initialise the babyActivities using fetch results
            babyActivities = fetchActivityResults
            // Fetch request
            let fetchSettingResults = try managedObjectContext!.executeFetchRequest(fetchSettings) as! [Settings]
            if fetchSettingResults.count == 0 {
                settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: managedObjectContext!) as? Settings
            }else{
            // Initialise the settings using fetch results
                settings = fetchSettingResults[0]
            }
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
