//
//  MapPinController.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation

import UIKit
import MapKit

class MapPinController: UIViewController, MKMapViewDelegate, UIWebViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                //pinView!.rightCalloutAccessoryView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "loadUrl:"))
                pinView!.animatesDrop = true
                pinView!.pinColor = .Green
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let url = NSURL(string: ((view.annotation?.subtitle)!)!)
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
    func loadUrl(recognizer:UITapGestureRecognizer) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        map.delegate = self
        mapSearchBar.delegate = self
        performUIUpdatesOnMain(){
            for annotations in self.appDelegate.annotationArray{
                self.map.addAnnotation(annotations)
            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        performUIUpdatesOnMain(){
            for annotations in self.appDelegate.annotationArray{
                self.map.removeAnnotation(annotations)
            }
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.appDelegate.annotationArray = []
        let param = ("{\"$regex\":\"[a-zA-z]*" + mapSearchBar.text! + "[a-zA-z]*\"" + "}").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        print(mapSearchBar.text!)
        //let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D"
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22mapString%22%3A\(param)%7D"
        print(urlString)
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */
                print(error?.description)
                return }
            let parsedResults: AnyObject!
            do{
                parsedResults = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            }
            catch{
                print("could not parse Json data")
                return
            }
            print(parsedResults)
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
                
            }
            performUIUpdatesOnMain(){
                let annotationsToRemove = self.map.annotations.filter { $0 !== self.map.userLocation }
                self.map.removeAnnotations( annotationsToRemove )
                for annotations in self.appDelegate.annotationArray{
                    self.map.addAnnotation(annotations)
                }
            }
        }
        task.resume()
        
    }
}