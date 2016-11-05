//
//  LiveStreamingController.swift
//  babyMonitor
//
//  Created by zjw on 27/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class LiveStreamingController: UIViewController, UIWebViewDelegate {

    @IBOutlet var babyWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        babyWebView.delegate = self
        // Configure webView
        babyWebView.scrollView.scrollEnabled = false
        babyWebView.scrollView.bounces = false
        babyWebView.opaque = true
        babyWebView.backgroundColor = UIColor.clearColor()
        // Webpage file location in server: /var/www/html/
        let videoUrl = Constants.cameraUrl
        babyWebView.allowsInlineMediaPlayback = true
        babyWebView.loadHTMLString(
            "<iframe width=\"\(self.babyWebView.frame.width)\" height=\"\(self.babyWebView.frame.height)\" src=\"\(videoUrl)?playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSizeZero)
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
