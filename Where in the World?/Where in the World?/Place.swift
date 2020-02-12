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
    // Name of the point of interest
    var name: String?
    
    // Description of the point of interest
    var longDescription: String?
    
    var latitude: Double?

    var longitude: Double?
    
    var type: Int?
    
}
