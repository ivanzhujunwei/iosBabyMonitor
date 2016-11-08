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
        case CRY, WET, COLD, OUTOFSIGHT, START, END
    }
class ActivityController: UITableViewController {
    
    var managedObjectContext : NSManagedObjectContext?
    
    // the activity list that is being displayed
    var babyActivities: [BabyActivity]!
    var settings: Settings!
    
//    var timePeriod : Double!
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    var timer:NSTimer!
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
        fetchData()
//        scheduleJobReadSensor()
        // Add notificatioin for reset settings
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetSettings), name: "resetSettingsId", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addActivityStartOrEnd), name: "addActivityStartOrEndId", object: nil)
    }
    
    // If user turn on the monitor switch, add a START activity
    // If user turn off the monitor switch, add a END activity
    func addActivityStartOrEnd(notification: NSNotification){
        let toogle = notification.object as! UISwitch
        if toogle.on{
            addBabyActivityInApp(BabyActityType.START.rawValue)
        }else{
            addBabyActivityInApp(BabyActityType.END.rawValue)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
    }
    
//    // Reset all the settings
    func resetSettings(notification: NSNotification){
        settings = notification.object as! Settings
        // Reset the timer
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        scheduleJobReadSensor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.translucent = true
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
        
        // Fetch for settings
        let fetchSettings = NSFetchRequest(entityName: "Settings")
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetch) as! [BabyActivity]
            // Initialise the babyActivities using fetch results
            babyActivities = fetchResults
            if babyActivities.count == 0 {
                addBabyActivity(BabyActityType.START.rawValue)
            }
            // Fetch request for settings
            let fetchSettingResults = try managedObjectContext!.executeFetchRequest(fetchSettings) as! [Settings]
            if fetchSettingResults.count == 0 {
                settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: managedObjectContext!) as! Settings
                settings.babyCryVolume = 1700
            }else{
            // Initialise the babyActivities using fetch results
                settings = fetchSettingResults[0]
            }
            
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
        // Set tableViewCell activityName
        if babyActivity.type == BabyActityType.START.rawValue || babyActivity.type == BabyActityType.END.rawValue{
            activityCell.activityName.text = babyActivity.activityName!
        }else{
            activityCell.activityName.text = settings.babyName! + " " + babyActivity.activityName!
        }
        if babyActivity.type == BabyActityType.START.rawValue {
            let dateTxt = getDateText(babyActivity.date!)
            let appendStr = "on \(dateTxt)" as String
            activityCell.activityName.text? += appendStr
        }
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
    
    // MARK: Timely job to read sensors
    func scheduleJobReadSensor(){
        if Bool(settings.monitor!) {
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(settings.timePeriod!), target: self, selector: #selector(ActivityController.readSensors), userInfo: nil, repeats: true)
        }
    }

    // MARK: read from sensors
    // Read data from different sensors
    func readSensors(){
        // Read from sound sensor
        if settings.babyCryOn == 1 {
            readSoundData()
        }
        // Read from mositure sensor
        if settings.diaperWetOn == 1 {
//            readMositureData()
        }
        // Read from the temperature sensor
        if settings.tempAnomaly == 1 {
            //Read from the temperature sensor
            readTempData()
            let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
            homeController.viewWillAppear(true)

        }
        // Refresh Home page 
        
    }
    
    // Read temperature data
    func readTempData(){
        let url = NSURL(string: Constants.temperatureUrl)!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj[0]
                let temp = sensorData["celsiusData"] as! Double
                self.settings.temperature = temp
                // If the temperature is below than 25, alert will prompt up
                if temp < 27 {
                    if !self.ifSameActivityIn2Min(BabyActityType.COLD.rawValue){
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " kicked off quilt.")
                        self.addBabyActivityInApp(BabyActityType.COLD.rawValue)
                    }
                }
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    }
    
    // Read mositure data
    func readMositureData(){
        let url = NSURL(string: Constants.mositureUrl)!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj[0]
                let mositure = sensorData["moisture"] as! Double
                // If the baby cry
                if mositure >= 700 {
                    // Add the peed activity
                    if !self.ifSameActivityIn2Min(BabyActityType.WET.rawValue){
                        print("Baby peed...")
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " peed.")
                        self.addBabyActivityInApp(BabyActityType.WET.rawValue)
                    }
                }else{
                    if !self.ifSameActivityIn2Min(BabyActityType.CRY.rawValue){
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " cried, was missing you")
                        print("Baby's diaper is dry")
                    }
                }
                
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    }
    


    // Read data from sound server
    func readSoundData(){
        let url = NSURL(string: Constants.soundUrl)!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj[0]
                if sensorData["frequency"] == nil{
                    return
                }
                let volume = sensorData["frequency"] as! Double
                // If the baby cry
                if volume >= Double(self.settings.babyCryVolume!){
                    let babyName = self.settings.babyName!
                    let warning = "Warning"
                    print("------------Start--------------")
                    self.addBabyActivityInApp(BabyActityType.CRY.rawValue)
                    let outOfSightOrnot = self.detect()
                    // If the baby is out of sight
                    if outOfSightOrnot == "OutOfSight" {
                        print("Baby was out of sight...")
                        if !self.ifSameActivityIn2Min(BabyActityType.OUTOFSIGHT.rawValue){
                            self.showAlertWithDismiss(warning, message: babyName + " was out of sight.")
                            self.addBabyActivityInApp(BabyActityType.OUTOFSIGHT.rawValue)
                        }
                    }else if outOfSightOrnot == "Detected"{
                        // If baby is in sight and peed
                        if self.settings.diaperWetOn == 1 {
                            print("Face detected, then detect if baby peed or not")
                            self.readMositureData()
                        }
                    }
                    // Add the cry activity
//                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3000 * Int64(NSEC_PER_MSEC))
//                        dispatch_after(time, dispatch_get_main_queue()) {
//                            self.showAlertWithDismiss(warning, message: babyName + " cried, was missing you")
//                            print("Baby cried, was missing you...")
//                            print("------------------End----------\n")
//                    }
                }
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    }
    
    // Detect if the baby is out of sight
    func detect() -> String{
        let url:NSURL = NSURL(string: Constants.cameraHideUrl)!
        let data = NSData(contentsOfURL:url)
        if data == nil{
            return "NoData"
        }
        let hideBabyPhoto = UIImage(data:data!)
        guard let personciImage = CIImage(image: hideBabyPhoto!)
        else {
            return "Unknown"
        }
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector!.featuresInImage(personciImage) as! [CIFaceFeature]
        if faces.count == 0 {
//            addBabyActivityInApp(BabyActityType.OUTOFSIGHT.rawValue)
            return "OutOfSight"
        }
        return "Detected"
    }
    
    // detect if the activity is same inside 2 miniutes
    func ifSameActivityIn2Min(type:String) -> Bool{
        if babyActivities.count == 0 {
            return false
        }
        let activities : [BabyActivity] = babyActivities.reverse()
        for activity in activities {
            // If the time interval between the two activities with same type is less than 5 miniutes
            // Then the APP will not record this activity as well as not sending notifications
            if activity.type == type {
                print(minutesFrom(activity.date!))
                if minutesFrom(activity.date!) < 2 {
                    return true
                }else{
                    return false
                }
//                return minutesFrom(activity.date!) < 2
            }
        }
        return false
    }

    // Add a baby activity with checkings and reloading
    func addBabyActivityInApp(type:String){
        // If the activity is starting monitor or ending monitor, it is not the same activity
        if type != BabyActityType.START.rawValue && type != BabyActityType.END.rawValue {
            // If the activity is the same in 5 miniutes, do not append
            if ifSameActivityIn2Min(type){
//                print("Activity in 2 miniutes, return")
                return
            }
        }
        addBabyActivity(type)
        self.tableView.reloadData()
        // Refresh home page
        let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
        homeController.viewWillAppear(true)
        viewWillAppear(true)
    }
    
    // Only add a baby activity
    func addBabyActivity(type:String){
        let newActivity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        newActivity.type = type
        newActivity.initByType()
        babyActivities.append(newActivity)
        do{
            try managedObjectContext!.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    // Show different alert based on different baby activities
//    func showAlertForActivities(type:String){
//        let babyName : String = settings.babyName!
//        var warningInfo :String = ""
//        if type == BabyActityType.COLD.rawValue {
//        }else if type == BabyActityType.WET.rawValue{
//        }else if type == BabyActityType.Cry
//        switch type{
//        case BabyActityType.COLD.rawValue:
//            print("Baby kicked off quilt...")
//            warningInfo = babyName + " kicked off quilt!"
//            break
////        case BabyActityType.CRY.rawValue:
////            warningInfo = babyName + " cried, was missing you!"
////            break
//        case BabyActityType.WET.rawValue:
//            warningInfo = babyName + " peed!"
//            break
//        default:
//            warningInfo = babyName + " was out of sight!"
//            break
//        }
//        showAlertWithDismiss("Warning", message: warningInfo)
//    }
    
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


    // MARK: - Navigation
    var pieChartData :  Dictionary<String, Int>!
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "chartSeg"{
            pieChartData  =  Dictionary<String, Int>()
            for i in 0 ..< babyActivities.count {
                let activity = babyActivities[i]
                if activity.type != BabyActityType.START.rawValue && activity.type != BabyActityType.END.rawValue
                {
                    let key = activity.type!
                    if  pieChartData.indexForKey(key) == nil {
                        pieChartData.updateValue(1, forKey: key)
                    }else{
                        let v = pieChartData[key]! + 1
                        pieChartData.updateValue(v, forKey: key)
                    }
                }
            }
            if pieChartData.count == 0{
                self.showAlertWithDismiss("Reminder", message: "No activity yet.")
                return false
            }
        //Continue with the segue
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chartSeg" {
            let cont = segue.destinationViewController as! ShinobiChartController
            cont.babyActivities = self.babyActivities
            cont.babyName = settings.babyName
            cont.pieChartData = pieChartData
        }
    }

}
