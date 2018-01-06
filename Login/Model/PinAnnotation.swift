//
//  PinAnnotation.swift
//  Login
//
//  Created by George on 06/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
}
