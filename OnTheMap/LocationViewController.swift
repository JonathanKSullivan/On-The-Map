//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/9/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var locationAddress: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationLabel1: UILabel!
    @IBOutlet weak var locationLabel2: UILabel!
    @IBOutlet weak var locationLabel3: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        map.delegate = self
        
    }

    
    @IBAction func findOnMap(sender: UIButton) {
        print(locationAddress.text!)
        let address = locationAddress.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            if let placemark = $0.0![0] as? CLPlacemark {
                performUIUpdatesOnMain(){
                    self.map.addAnnotation(MKPlacemark(placemark: placemark))
                    var region = MKCoordinateRegion()
                    region.center.latitude = placemark.location!.coordinate.latitude;
                    region.center.longitude = placemark.location!.coordinate.longitude;
                    region.span.latitudeDelta = 0.3;
                    region.span.longitudeDelta = 0.3;
                    self.map.hidden = false
                    self.urlTextField.hidden = false
                    self.submitButton.hidden = false
                    self.locationAddress.hidden = true
                    self.locateButton.hidden = true
                    self.locationLabel1.hidden = true
                    self.locationLabel2.hidden = true
                    self.locationLabel3.hidden = true
                    self.map.setRegion(region, animated: true)
                }
                self.appDelegate.mapString = address
                self.appDelegate.latitude = placemark.location!.coordinate.latitude 
                self.appDelegate.longitude = placemark.location!.coordinate.longitude
            }
        }
    }
    
    
    
    @IBAction func addToUdacityMapDB(sender: AnyObject) {
        self.appDelegate.mediaURL = urlTextField.text
        if self.appDelegate.userHasPin == false{
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"uniqueKey\": \"\(self.appDelegate.uniqueKey)\", \"firstName\": \"\(self.appDelegate.firstName)\", \"lastName\": \"\(self.appDelegate.lastName)\",\"mapString\": \"\(self.appDelegate.mapString)\", \"mediaURL\": \"\(self.appDelegate.mediaURL)\",\"latitude\": \(self.appDelegate.latitude), \"longitude\": \(self.appDelegate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            task.resume()
        }
        else{
            let urlString = "https://api.parse.com/1/classes/StudentLocation/8ZExGR5uX8"
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "PUT"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"uniqueKey\": \"\(self.appDelegate.uniqueKey)\", \"firstName\": \"\(self.appDelegate.firstName)\", \"lastName\": \"\(self.appDelegate.lastName)\",\"mapString\": \"\(self.appDelegate.mapString)\", \"mediaURL\": \"\(self.appDelegate.mediaURL)\",\"latitude\": \(self.appDelegate.latitude), \"longitude\": \(self.appDelegate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            }
            task.resume()

        }
        
    }
}