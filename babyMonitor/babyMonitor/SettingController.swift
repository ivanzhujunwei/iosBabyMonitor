//
//  SettingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

// This controller provide the configuration for this application
// User can turn on/off monitor and notification for baby crying, diaper wet, temperature anomaly
// User can choose a photo from local album as the background for home page and reset to default background
// User can set baby's name
class SettingController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SetBabyNameDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    // Application settings stored in Core data
    var settings:Settings!

    // Cells in the tableview
    var monitorCell : SettingCell!
    var cryCell : SettingCell!
    var diaperCell : SettingCell!
    var quiltCell : SettingCell!
    var monitorTimeCell : SettingTimePeriodCell!
    var volumeCell : SettingVolumeCell!
    var resetHomeImgCell : SettingDefaultImgCell!
    
    // MARK: Time period settings
    // 10 seconds
    let realTime = 10
    // 5 miniutes
    let fiveMin = 300
    // 15 miniutes
    let fifteenMin = 900
    
    // Application theme color
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        
        // set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.translucent = true
        // Remove blank rows
        tableView.tableFooterView = UIView()
        
        initCells()
        // Add target functions to different tableView Cells
        monitorCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffSubControls), forControlEvents: UIControlEvents.ValueChanged)
        cryCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffCryNotification), forControlEvents: UIControlEvents.ValueChanged)
        diaperCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffDiaperNotification), forControlEvents: UIControlEvents.ValueChanged)
        quiltCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffQuiltNotification), forControlEvents: UIControlEvents.ValueChanged)
        monitorTimeCell.timePeriod.addTarget(self, action: #selector(SettingController.changeTimePeriod), forControlEvents: UIControlEvents.ValueChanged)
        volumeCell.volumeSlider.addTarget(self, action: #selector(SettingController.changeVolume), forControlEvents: UIControlEvents.ValueChanged)
        resetHomeImgCell.resetHomeImg.addTarget(self, action: #selector(SettingController.resetHomeImge), forControlEvents: UIControlEvents.TouchDown)
    }
    
    // Initialise tableView cells
    func initCells(){
        monitorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SettingCell
        monitorTimeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! SettingTimePeriodCell

        cryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingCell
        volumeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! SettingVolumeCell
        diaperCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! SettingCell
        quiltCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1)) as! SettingCell
        resetHomeImgCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2)) as! SettingDefaultImgCell
        
        // Initialise status of switches
        if monitorCell.switchOnOff.on {
            cryCell.switchOnOff.enabled = true
            diaperCell.switchOnOff.enabled = true
            quiltCell.switchOnOff.enabled = true
            monitorTimeCell.timePeriod.enabled = true
        }else{
            cryCell.switchOnOff.enabled = false
            diaperCell.switchOnOff.enabled = false
            quiltCell.switchOnOff.enabled = false
            monitorTimeCell.timePeriod.enabled = false
        }
    }
    
    // Fetch current dataset
    func fetchData(){
        // Declare fetch entityName
        let fetch = NSFetchRequest(entityName: "Settings")
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetch) as! [Settings]
            if fetchResults.count == 0 {
                settings = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: managedObjectContext!) as! Settings
            }else{
                settings = fetchResults[0]
            }
        }catch{
            fatalError("Failed to fetch Settings information: \(error)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Two section in this tableView
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // first section: monitor control
        if section == 0{
            return 2
        }else if section == 1 {
            // second section: sub controls: baby cry, diaper wet, temperature
            return 4
        }else if section == 2{
            // third section: choose picture from ablum
            return 2
        }else {
            return 1
        }
    }
    
    // All sub monitors are controlled by the top monitor
    func turnOffSubControls(toggle: UISwitch){
        if toggle.on {
            settings?.monitor = true
            cryCell.switchOnOff.enabled = true
            diaperCell.switchOnOff.enabled = true
            quiltCell.switchOnOff.enabled = true
            monitorTimeCell.timePeriod.enabled = true
            volumeCell.volumeSlider.enabled = true
            
        }else{
            settings?.monitor = false
            cryCell.switchOnOff.enabled = false
            diaperCell.switchOnOff.enabled = false
            quiltCell.switchOnOff.enabled = false
            monitorTimeCell.timePeriod.enabled = false
            volumeCell.volumeSlider.enabled = false
        }
        // Reset settings
        NSNotificationCenter.defaultCenter().postNotificationName("resetSettingsId", object: settings)
        // Add START/END activity log
        NSNotificationCenter.defaultCenter().postNotificationName("addActivityStartOrEndId", object: toggle)
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // Save status of cry notification to core data entity
    func turnOffCryNotification(toggle: UISwitch){
        if toggle.on {
            settings.babyCryOn = true
            settings.diaperWetOn = true
            
            volumeCell.volumeSlider.enabled = true
            diaperCell.switchOnOff.enabled = true
            diaperCell.switchOnOff.on = true
        }else{
            settings.babyCryOn = false
            settings.diaperWetOn = false
            volumeCell.volumeSlider.enabled = false
            diaperCell.switchOnOff.enabled = false
            diaperCell.switchOnOff.on = false
        }
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
    }
    
    // Save status of diaper wet to core data entity
    func turnOffDiaperNotification(toggle: UISwitch){
        if toggle.on {
            settings.diaperWetOn = true
        }else{
            settings.diaperWetOn = false
        }
    }
    
    // Save status of kick off quilt to core data entity
    func turnOffQuiltNotification(toggle: UISwitch){
        if toggle.on {
            settings.tempAnomaly = true
        }else{
            settings.tempAnomaly = false
        }
    }
    
    // Save time period to core data entity
    func changeTimePeriod(){
        switch  monitorTimeCell.timePeriod.selectedSegmentIndex {
        case 0:
            settings.timePeriod = realTime
            break
        case 1:
            settings.timePeriod = fiveMin
            break
        default:
            settings.timePeriod = fifteenMin
            break
        }
        NSNotificationCenter.defaultCenter().postNotificationName("resetSettingsId", object: settings)
    }
    
    // User can change the sensetivity of baby cry notification
    // If the sensitivity is high, parents will get notified at a low volume when baby cry
    // If the sensitivity is low, parents will only get notified when baby cry severe
    func changeVolume(){
        let volume = 2200 - volumeCell.volumeSlider.value * 50
        let str = NSString(format: "%.f", volumeCell.volumeSlider.value)
        volumeCell.textLabel?.text = "Sensitive level  \(str)"
        settings.babyCryVolume = volume
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        
    }
    
    // Reset home page's image
    func resetHomeImge(){
        let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
        homeController.babyPhone.image = UIImage(named: "baby_smile")
        let imageData = UIImageJPEGRepresentation(homeController.babyPhone.image!, 1)
        settings.homePagePhoto = imageData
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        showAlertWithDismiss("Done", message: "Reset successfully")
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
                // Configure the cell
                settingCell.textLabel?.text = "Monitor"
                settingCell.switchOnOff.on = Bool(settings.monitor!)
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.None
                settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)
                return settingCell
            default:
                let monitorTimeCell = tableView.dequeueReusableCellWithIdentifier("monitorTimeCell", forIndexPath: indexPath) as! SettingTimePeriodCell
                monitorTimeCell.textLabel?.text = "Monitor interval"
                monitorTimeCell.selectionStyle = UITableViewCellSelectionStyle.None
                monitorTimeCell.contentView.bringSubviewToFront(monitorTimeCell.timePeriod)
                monitorTimeCell.timePeriod.selectedSegmentIndex = getIndexForTimePeriod()
                return monitorTimeCell
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.None
                settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)
                settingCell.textLabel?.text = "Baby cry"
                settingCell.switchOnOff.on = Bool(settings.babyCryOn!)
                return settingCell
            case 1:
                let volumeCell = tableView.dequeueReusableCellWithIdentifier("volumeCell", forIndexPath: indexPath) as! SettingVolumeCell
                volumeCell.textLabel!.text = "Sensitive level"
                volumeCell.selectionStyle = UITableViewCellSelectionStyle.None
                volumeCell.volumeSlider.value = (2200 - Float(settings.babyCryVolume!) ) / 50
                volumeCell.contentView.bringSubviewToFront(volumeCell.volumeSlider)
                return volumeCell
            case 2:
                let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.None
                settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)

                settingCell.textLabel?.text = "Diaper wet"
                settingCell.switchOnOff.on = Bool(settings.diaperWetOn!)
                return settingCell
            default:
                let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.None
                settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)

                settingCell.textLabel?.text = "Temperature anomaly"
                settingCell.switchOnOff.on = Bool(settings.tempAnomaly!)
                return settingCell
                
            }
        }else if indexPath.section == 2{
            switch indexPath.row{
            case 0:
                let choosePhotoCell = tableView.dequeueReusableCellWithIdentifier("choosePhotoCell", forIndexPath: indexPath) as UITableViewCell
                choosePhotoCell.textLabel?.text = "Choose from Photos"
                return choosePhotoCell
            default:
                let defaultImgCell = tableView.dequeueReusableCellWithIdentifier("defaultImgCell", forIndexPath: indexPath) as! SettingDefaultImgCell
                defaultImgCell.textLabel?.text = "Use default home page"
                // set none select style
                defaultImgCell.selectionStyle = UITableViewCellSelectionStyle.None
                defaultImgCell.contentView.bringSubviewToFront(defaultImgCell.resetHomeImg)
                return defaultImgCell
                
            }
        }else{
            let babyNameCell = tableView.dequeueReusableCellWithIdentifier("babyNameCell", forIndexPath: indexPath) as! SettingNameCell
            
            babyNameCell.textLabel?.text = "Baby's name"
            babyNameCell.babyNameLabel.text = settings.babyName
            babyNameCell.contentView.bringSubviewToFront(babyNameCell.babyNameLabel)
//            babyNameCell.textLabel.text = "Bab"
            return babyNameCell
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // If the user click to select a photo
        if indexPath.section == 2 && indexPath.row == 0{
            // Reference: www.youtube.com/watch?v=leyk3QOYJF0
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .PhotoLibrary
            self.presentViewController(photoPicker, animated: true, completion: nil)
        }
    }
    
    // execute after picking a picutre
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let imageData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1)
        settings.homePagePhoto = imageData
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        
        //let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
        //homeController.babyPhone.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !monitorCell.switchOnOff.on {
            volumeCell.volumeSlider.enabled = false
        }
        // reload data
        self.tableView.reloadData()
    }
    
    func getIndexForTimePeriod() -> Int{
        let timeSetting = Int(settings.timePeriod!)
        switch timeSetting{
        // Real time
        case realTime:return 0
        // 5 miniutes
        case fiveMin: return 1
        // 15 miniutes
        default: return 2
        }
    }
    
    // Delegate
    func setBabyName(name: String) {
        settings.babyName = name
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }

    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "babyNameSeg" {
            let controller = segue.destinationViewController as! BabyNameController
            controller.setBabyNameDelegate = self
            controller.name = settings.babyName
        }
    }

}
