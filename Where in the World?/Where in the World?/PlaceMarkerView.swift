//
//  PlaceMarkerView.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/9/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
          clusteringIdentifier = "Place"
          displayPriority = .defaultLow
          markerTintColor = .systemRed
          glyphImage = UIImage(systemName: "pin.fill")
          }
    }
}
