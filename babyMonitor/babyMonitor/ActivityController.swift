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
    
    var timePeriod : Double!
    
    var timer:NSTimer!
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
        
        fetchData()
        readSensors()
        // Add notificatioin for updating monitoring regions
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resetTimePeriod), name: "changeTimePeriodId", object: nil)
    }
    
    func resetTimePeriod(notification: NSNotification){
        let setting = notification.object as! Settings
        timePeriod = Double(setting.timePeriod!)
        // Reset the timer
        timer.invalidate()
        timer = nil
        readSensors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mockup: new BabyActivity object
        // TODO: FROM SERVER
//        let activity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
//        activity.type = BabyActityType.CRY.rawValue
//        activity.initByType()
//        
//        let activity2 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
//        activity2.type = BabyActityType.WET.rawValue
//        activity2.initByType()
//        
//        let activity3 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
//        activity3.type = BabyActityType.COLD.rawValue
//        activity3.initByType()
//
//        
//        let activity0 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
//        activity0.type = BabyActityType.START.rawValue
//        activity0.initByType()
        
        
//        babyActivities.append(activity0)
//        babyActivities.append(activity)
//        babyActivities.append(activity2)
//        babyActivities.append(activity3)
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
            // Fetch request for settings
            let fetchSettingResults = try managedObjectContext!.executeFetchRequest(fetchSettings) as! [Settings]
            // Initialise the babyActivities using fetch results
            settings = fetchSettingResults[0]
            timePeriod = Double(settings.timePeriod!)
            
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
    
    // MARK: Read sensors
    func readSensors(){
        timer = NSTimer.scheduledTimerWithTimeInterval(timePeriod, target: self, selector: #selector(ActivityController.readSoundData), userInfo: nil, repeats: true)
        
        
    }

    func readSoundData(){
        let url = NSURL(string: "http://172.20.10.5:6900/")!
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
                let cryBool = sensorData["cryBool"] as! Bool
                // If the baby cry
                if cryBool{
                    print("Baby crying...")
                    // Add the cry activity
                    self.addBabyActivity(BabyActityType.CRY.rawValue)
                }else{
                    let url:NSURL = NSURL(string:"http://172.20.10.5/cam.jpg")!
                    let data = NSData(contentsOfURL:url)
                    if data != nil{
                        let hideBabyPhoto = UIImage(data:data!)
                        // TEST: Detect if the baby is out of sight
                        self.detect(hideBabyPhoto!)
                    }
                    print("222")
                }
                
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    }
    
    
    func detect(image:UIImage) {
        guard let personciImage = CIImage(image: image) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector!.featuresInImage(personciImage)
        
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height)
        
        var detected: Bool = false
        
        for face in faces as! [CIFaceFeature] {
            print("Found bounds are \(face.bounds)")
            // Apply the transform to convert the coordinates
//            let faceViewBounds = CGRectApplyAffineTransform(face.bounds, transform)
//            let faceBox = UIView(frame: faceViewBounds)
//            faceBox.layer.borderWidth = 3
//            faceBox.layer.borderColor = UIColor.redColor().CGColor
//            faceBox.backgroundColor = UIColor.clearColor()
            let alert = UIAlertController(title: "Say Cheese!", message: "We detected that your baby is in the bed crib!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            detected = true
            
        }
        // If baby is out of sight
        if detected{
            let newActivity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
            newActivity.type = BabyActityType.CRY.rawValue
            newActivity.initByType()
            
            babyActivities.append(newActivity)
//            NSNotificationCenter.defaultCenter().postNotificationName("addBabyActivityId", object: nil)
        }else{
            addBabyActivity(BabyActityType.OUTOFSIGHT.rawValue)
//            let alert = UIAlertController(title: "Warning!", message: "Your baby is out of sight!", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // detect if the activity is same inside 5 miniutes
    func ifSameActivityIn5Min() -> Bool{
        if babyActivities.count == 0 {
            return false
        }
        let lastActivity = babyActivities[babyActivities.count - 1]
        return minutesFrom(lastActivity.date!) < 5
    }
    
    // Returns the amount of minutes from another date
    func minutesFrom(date: NSDate) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = NSDate()
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: currentDate, options: []).minute
    }
    
    // Add a baby activity
    func addBabyActivity(type:String){
        // If the activity is the same in 10 miniutes, do not append
        if !ifSameActivityIn5Min() {
            let newActivity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
            newActivity.type = BabyActityType.OUTOFSIGHT.rawValue
            newActivity.initByType()
            babyActivities.append(newActivity)
            do{
                try managedObjectContext!.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
            self.tableView.reloadData()
        }
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
    
    // MARK: ALERT
    // Helper function to produce an alert for the user
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
