//
//  Place.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/9/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit
import MapKit

class Place: MKPointAnnotation, Codable {
    /*func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(longDescription, forKey: "description")
        coder.encode(latitude, forKey: "lat")
        coder.encode(longitude, forKey: "long")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String
        longDescription = coder.decodeObject(forKey: "description") as? String
        latitude = coder.decodeObject(forKey: "lat") as? Double
        longitude = coder.decodeObject(forKey: "long") as? Double
    }*/
    
    // Name of the point of interest
    var name: String?
    
    // Description of the point of interest
    var longDescription: String?
    
    var latitude: Double?

    var longitude: Double?
    
    var type: Int?
    
}
