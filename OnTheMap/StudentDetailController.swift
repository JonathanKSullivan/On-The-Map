//
//  UdacityAuthViewController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation

import UIKit

class StudentDetailController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var requestToken: String? = nil
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelDetail")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            performUIUpdatesOnMain(){
                self.webView.loadRequest(self.urlRequest!)
            }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.navigationItem.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
    
    // MARK: - UIWebViewDelegate
    
    func cancelDetail() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}