//
//  SettingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class SettingController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    var settings:Settings!

    var monitorCell : SettingCell!
    var cryCell : SettingCell!
    var diaperCell : SettingCell!
    var quiltCell : SettingCell!
    var monitorTimeCell : SettingTimePeriodCell!
    var volumeCell : SettingVolumeCell!
    
    // Time period settings
    // 10 seconds
    let realTime = 10
    // 5 miniutes
    let fiveMin = 300
    // 15 miniutes
    let fifteenMin = 900
    
    
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
        monitorCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffSubControls), forControlEvents: UIControlEvents.ValueChanged)
        cryCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffCryNotification), forControlEvents: UIControlEvents.ValueChanged)
        diaperCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffDiaperNotification), forControlEvents: UIControlEvents.ValueChanged)
        quiltCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffQuiltNotification), forControlEvents: UIControlEvents.ValueChanged)
        monitorTimeCell.timePeriod.addTarget(self, action: #selector(SettingController.changeTimePeriod), forControlEvents: UIControlEvents.ValueChanged)
        volumeCell.volumeSlider.addTarget(self, action: #selector(SettingController.changeVolume), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // Initialise tableView cells
    func initCells(){
        monitorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SettingCell
        monitorTimeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! SettingTimePeriodCell

        cryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingCell
        volumeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! SettingVolumeCell
        diaperCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! SettingCell
        quiltCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1)) as! SettingCell
        
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // first section: monitor control
        if section == 0{
            return 2
        }else if section == 1 {
            // second section: sub controls: baby cry, diaper wet, temperature
            return 4
        }else{
            // third section: choose picture from ablum
            return 2
        }
    }
    
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
        NSNotificationCenter.defaultCenter().postNotificationName("resetSettingsId", object: settings)
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
            volumeCell.volumeSlider.enabled = true
        }else{
            volumeCell.volumeSlider.enabled = false
            settings.babyCryOn = false
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
    
    func changeVolume(){
        let volume = Int(volumeCell.volumeSlider.value * 10 / 1500)
        volumeCell.textLabel?.text = "Change volume  \(volume)"
        settings.babyCryVolume = volumeCell.volumeSlider.value
        
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
                monitorTimeCell.textLabel?.text = "Time period"
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
                volumeCell.textLabel!.text = "Change volume"
                volumeCell.selectionStyle = UITableViewCellSelectionStyle.None
                volumeCell.volumeSlider.value = Float(settings.babyCryVolume!)
//                volumeCell.volumeSlider.enabled = settings.babyCryOn == 1
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
        }else{
            switch indexPath.row{
            case 0:
                let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
                settingCell.textLabel?.text = "Use default home page"
                settingCell.switchOnOff.on = Bool(settings.useDefaultHomePage!)
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.None
                settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)
                return settingCell
            default:
                
                let choosePhotoCell = tableView.dequeueReusableCellWithIdentifier("choosePhotoCell", forIndexPath: indexPath) as UITableViewCell
                choosePhotoCell.textLabel?.text = "Choose from Photos"
                return choosePhotoCell
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // If the user click to select a photo
        if indexPath.section == 2 && indexPath.row == 1{
            // Reference: www.youtube.com/watch?v=leyk3QOYJF0
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .PhotoLibrary
            self.presentViewController(photoPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
        homeController.babyPhone.image = info[UIImagePickerControllerOriginalImage] as? UIImage
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
