//
//  TablePinController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation

import UIKit
import MapKit
class TablePinController: UITableViewController{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.annotationArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let students = appDelegate.annotationArray
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = student.title
       
        return cell
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let students = appDelegate.annotationArray
        let url = NSURL(string: students[indexPath.row].subtitle!)
        let request = NSURLRequest(URL: url!)
        let DetailController = self.storyboard!.instantiateViewControllerWithIdentifier("StudentDetailController") as! StudentDetailController
        DetailController.urlRequest = request
        DetailController.completionHandler = {
            if $0{
                return
            }
            if ($1 != nil){
                print($1)
            }
        }
        let detailNavigationController = UINavigationController()
        detailNavigationController.pushViewController(DetailController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(detailNavigationController, animated: true, completion: nil)
        })
    }


}