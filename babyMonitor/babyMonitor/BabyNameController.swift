//
//  BabyNameController.swift
//  babyMonitor
//
//  Created by zjw on 4/11/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

protocol  SetBabyNameDelegate {
    func setBabyName(name:String)
}

// This controller is only for setting baby's name
class BabyNameController: UIViewController {
    
    var setBabyNameDelegate : SetBabyNameDelegate?

    @IBOutlet weak var babyNameText: UITextField!
    
    var name:String!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        babyNameText = UITextField()
//    }
    
    @IBAction func setBabyName(sender: AnyObject) {
        
        setBabyNameDelegate!.setBabyName(babyNameText.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        babyNameText.text = name
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
