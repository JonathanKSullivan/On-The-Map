//
//  UdacityAuthViewController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation

import UIKit

class UdacityAuthViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        self.navigationItem.title = "Udacity"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelAuth")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            self.webView.loadRequest(urlRequest!)
            
        }
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(webView.request!.URL!.absoluteString == "https://www.udacity.com/me#!/") {
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.completionHandler!(success: true, errorString: nil)
            })
        }
    }
    
    func cancelAuth() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}