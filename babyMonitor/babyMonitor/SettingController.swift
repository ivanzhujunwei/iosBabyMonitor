//
//  SettingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove blank rows
        tableView.tableFooterView = UIView()
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let settingCell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
        if indexPath.section == 0 {
            // Configure the cell
            settingCell.textLabel?.text = "Monitor"
        }
        else {
            switch indexPath.row {
            case 0:
                settingCell.textLabel?.text = "Baby cry"
                settingCell.switchOnOff.on = false
                break
            case 1:
                settingCell.textLabel?.text = "Diaper wet"
                break
            default:
                settingCell.textLabel?.text = "Temperature anomaly"
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
