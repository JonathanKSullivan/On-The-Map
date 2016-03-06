//
//  TabPinController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FBSDKLoginKit

class TabPinController: UITabBarController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "On The Map"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Pin", style: .Plain, target: self, action: "addPin:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout:")
        self.tabBar.items?.first?.image = UIImage(named: "map")
        self.tabBar.items?.first?.title = "Map"
        self.tabBar.items?.last?.image =  UIImage(named: "list")
        self.tabBar.items?.last?.title = "List"
    }
    func addPin(sender: UIBarButtonItem){
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("newPin", sender: self)
        })
    }
    func logout(sender: UIBarButtonItem){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            self.dismissViewControllerAnimated(true){
                if (FBSDKAccessToken.currentAccessToken() != nil)
                {
                    self.appDelegate.annotationArray = []
                    FBSDKLoginButton().sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                }

            }
            
        }
        task.resume()
    }
}