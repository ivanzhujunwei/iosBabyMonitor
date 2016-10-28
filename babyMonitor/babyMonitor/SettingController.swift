//
//  SettingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
import CoreData

class SettingController: UITableViewController {
    
    var managedObjectContext : NSManagedObjectContext!
    var settings:Settings!

    var monitorCell : SettingCell!
    var cryCell : SettingCell!
    var diaperCell : SettingCell!
    var quiltCell : SettingCell!
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        fetchData()
        super.viewDidLoad()
        // Remove blank rows
        tableView.tableFooterView = UIView()
        
        initCells()
        monitorCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffSubControls), forControlEvents: UIControlEvents.ValueChanged)
        cryCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffCryNotification), forControlEvents: UIControlEvents.ValueChanged)
        diaperCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffDiaperNotification), forControlEvents: UIControlEvents.ValueChanged)
        quiltCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffQuiltNotification), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func initCells(){
        monitorCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SettingCell
        cryCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingCell
        diaperCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! SettingCell
        quiltCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! SettingCell
        if monitorCell.switchOnOff.on {
            cryCell.switchOnOff.enabled = true
            diaperCell.switchOnOff.enabled = true
            quiltCell.switchOnOff.enabled = true
        }else{
            cryCell.switchOnOff.enabled = false
            diaperCell.switchOnOff.enabled = false
            quiltCell.switchOnOff.enabled = false
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
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1 {
            return 3
        }else{
            return 0
        }
    }
    
    func turnOffSubControls(toggle: UISwitch){
        if toggle.on {
            settings?.monitor = true
            cryCell.switchOnOff.enabled = true
            diaperCell.switchOnOff.enabled = true
            quiltCell.switchOnOff.enabled = true
        }else{
            settings?.monitor = false
            cryCell.switchOnOff.enabled = false
            diaperCell.switchOnOff.enabled = false
            quiltCell.switchOnOff.enabled = false
        }
//        do{
//            try managedObjectContext.save()
//        }catch{
//            fatalError("Failure to save context: \(error)")
//        }
    }
    
    func turnOffCryNotification(toggle: UISwitch){
        if toggle.on {
            settings.babyCryOn = true
        }else{
            settings.babyCryOn = false
        }
    }
    
    func turnOffDiaperNotification(toggle: UISwitch){
        if toggle.on {
            settings.diaperWetOn = true
        }else{
            settings.diaperWetOn = false
        }
    }
    
    func turnOffQuiltNotification(toggle: UISwitch){
        if toggle.on {
            settings.tempAnomaly = true
        }else{
            settings.tempAnomaly = false
        }
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
        if indexPath.section == 0 {
            // Configure the cell
            settingCell.textLabel?.text = "Monitor"
            settingCell.switchOnOff.on = Bool(settings.monitor!)
        }
        else {
            switch indexPath.row {
            case 0:
                settingCell.textLabel?.text = "Baby cry"
                settingCell.switchOnOff.on = Bool(settings.babyCryOn!)
                break
            case 1:
                settingCell.textLabel?.text = "Diaper wet"
                settingCell.switchOnOff.on = Bool(settings.diaperWetOn!)
                break
            default:
                settingCell.textLabel?.text = "Temperature anomaly"
                settingCell.switchOnOff.on = Bool(settings.tempAnomaly!)
                break
            }
        }
        // set none select style
        settingCell.selectionStyle = UITableViewCellSelectionStyle.None
        settingCell.contentView.bringSubviewToFront(settingCell.switchOnOff)
        return settingCell
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
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
