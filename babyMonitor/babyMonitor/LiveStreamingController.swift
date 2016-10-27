//
//  LiveStreamingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class LiveStreamingController: UIViewController {

    @IBOutlet var babyWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoUrl = "http://118.139.40.217"
//        let imageUrl = "http://118.139.40.217/cam.jpg"
        babyWebView.allowsInlineMediaPlayback = true
        babyWebView.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"\(videoUrl)?playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
//        babyWebView.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"\(imageUrl)?playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
