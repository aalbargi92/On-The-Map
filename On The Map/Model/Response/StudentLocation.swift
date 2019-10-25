//
//  StudentLocation.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation: NSObject, MKAnnotation, Codable {
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String?
    var uniqueKey: String
    var createdAt: String?
    var updatedAt: String?
    
    var title: String? {
        return "\(firstName) \(lastName)"
    }
    
    var subtitle: String? {
        return mediaURL
    }
    
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    init(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
    }
    
    override init() {
        self.firstName = ""
        self.lastName = ""
        self.latitude = 0
        self.longitude = 0
        self.mapString = ""
        self.mediaURL = ""
        self.uniqueKey = ""
    }
}
