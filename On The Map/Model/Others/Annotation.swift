//
//  Annotation.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    override init() {
        coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
