//
//  MapAnnotation.swift
//  OnTheMap
//
//  Created by Jonathan K Sullivan  on 2/8/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation, MKMapViewDelegate {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}