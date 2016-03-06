//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/7/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MapKit

class ViewController: UIViewController, UIWebViewDelegate, FBSDKLoginButtonDelegate{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    var loginView : FBSDKLoginButton


    required init?(coder aDecoder: NSCoder) {
        loginView  = FBSDKLoginButton()
        super.init(coder: aDecoder)
        print("a")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 249.0/255, green: 144.0/255, blue: 35.0/255, alpha: 1)
        let userNamePaddingView = UIView(frame: CGRectMake(0, 0, 15, self.userName.frame.height))
        userName.leftView = userNamePaddingView
        userName.leftViewMode = UITextFieldViewMode.Always
        let passwordPaddingView = UIView(frame: CGRectMake(0, 0, 15, self.password.frame.height))
        password.leftView = passwordPaddingView
        password.leftViewMode = UITextFieldViewMode.Always
        
        loginView  = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.frame.size.width = self.view.frame.width - self.view.frame.width/10
        loginView.frame.size.height = loginButton.frame.height
        loginView.center = self.view.center
        loginView.frame.origin.y = self.view.frame.height - 2*loginView.frame.height
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            
            
        }
    }
       @IBAction func LoginAction(sender: UIButton) {
        let credentialDict = ["username": userName.text!, "password": password.text!]
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(credentialDict["username"]!)\", \"password\": \"\(credentialDict["password"]!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let parsedResults: AnyObject!
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do{
                parsedResults = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            }
            catch{
                print("could not parse Json data")
                return
                
            }
            self.getInfo(parsedResults)
        }
        task.resume()
    }
    @IBAction func SignUpAction(sender: UIButton) {
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        let request = NSURLRequest(URL: url!)
        let webAuthViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UdacityAuthViewController") as! UdacityAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.completionHandler = {
            if $0{
                return
            }
            if ($1 != nil){
                print($1)
            }
        }
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        })
        
    }
    
     func facebookAuth() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(FBSDKAccessToken.currentAccessToken().tokenString);\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error...
                return
            }
            let parsedResults: AnyObject!

            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do{
                parsedResults = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            }
            catch{
                print("could not parse Json data")
                return
                
            }
            self.getInfo(parsedResults)
        }
        task.resume()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                facebookAuth()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let id : NSString = result.valueForKey("id") as! NSString
                print("User ID is: \(id)")
            }
        })
    }
    func getInfo(parsedResults: AnyObject){
        let key = parsedResults["account"]!!["key"]!!
        print(key)
        print(parsedResults)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(key)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let newParsedResults: AnyObject!
            do{
                newParsedResults = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            }
            catch{
                print("could not parse Json data")
                return
            }
            print(newParsedResults)
            self.appDelegate.uniqueKey = key as! String
            self.appDelegate.firstName = newParsedResults["user"]!!["first_name"] as! String
            self.appDelegate.lastName = newParsedResults["user"]!!["last_name"] as! String
            self.showMap(parsedResults)
        }
        task.resume()
    }
    func showMap(parsedResults: AnyObject){
        let DetailController = self.storyboard!.instantiateViewControllerWithIdentifier("TabPinController") as! TabPinController
            let detailNavigationController = UINavigationController()
            detailNavigationController.pushViewController(DetailController, animated: false)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(detailNavigationController, animated: true, completion: nil)
            })
    }
 
    override func viewWillDisappear(animated: Bool) {
        self.appDelegate.annotationArray = []
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let parsedResults: AnyObject!
            do{
                parsedResults = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            }
            catch{
                print("could not parse Json data")
                return
            }
            var location: CLLocationCoordinate2D
            var annotation: MapAnnotation
            var name: String
            var link: String
            for student in parsedResults["results"]!! as! [[String:AnyObject]]{
                location = CLLocationCoordinate2D(latitude: CLLocationDegrees(student["latitude"]! as! NSNumber), longitude: CLLocationDegrees(student["longitude"]! as! NSNumber))
                name = (student["firstName"]! as! String) + " " + (student["lastName"]! as! String)
                link = student["mediaURL"] as! String
                annotation = MapAnnotation(coordinate: location, title: name, subtitle: link)
                self.appDelegate.annotationArray.append(annotation)
                print(student["uniqueKey"] as! String)
                if self.appDelegate.uniqueKey == (student["uniqueKey"] as! String){
                    self.appDelegate.userHasPin = true
                }
            }
            print(parsedResults)
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

