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

class HomeController: UIViewController {

    @IBOutlet var babyPhone: UIImageView!
    
    // lastest updated temperature
    @IBOutlet var latestUpdateTemp: UILabel!
    
    var managedObjectContext : NSManagedObjectContext?
    
    var settings:Settings?
    
    let themeColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set home page photo
        babyPhone.image = UIImage(named: "baby_smile")
        // temperature text
        // TODO: FROM SENSOR
        latestUpdateTemp.text = "24°C"
        latestUpdateTemp.textColor = themeColor
        
        // set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.translucent = true
//        while true{
//        }
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
        let fetch = NSFetchRequest(entityName: "Settings")
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetch) as! [Settings]
            // Initialise the settings using fetch results
            settings = fetchResults[0]
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
