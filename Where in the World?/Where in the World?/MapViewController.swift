//
//  MapViewController.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/9/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var locationTitle: UILabel!
    @IBOutlet var locationDescription: UILabel!
    
    //let locationManager = CLLocationManager()
    let id = MKMapViewDefaultAnnotationViewReuseIdentifier
    var annotations: [Place] = []
    
    var currentPlace = Place()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // values come approximately from this source but adjusted for my purposes:
        // https://en.wikipedia.org/wiki/Module:Location_map/data/United_States_Chicago
        let chicagoLongLat = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
        let chicagoSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.25)
        mapView.region = MKCoordinateRegion(center: chicagoLongLat, span: chicagoSpan)
        
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: id)
        
        annotations = DataManager.sharedInstance.loadAnnotationFromPlist()
        for annotation in annotations {
            let location = CLLocationCoordinate2D(latitude: annotation.latitude!, longitude: annotation.longitude!)
            annotation.coordinate = location
            annotation.title = annotation.name
            annotation.subtitle = annotation.longDescription
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: id, for: annotation) as? MKMarkerAnnotationView else {
            return nil
        }

        annotationView.animatesWhenAdded = true

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Place else { return }
        
        locationTitle.text = annotation.name
        locationDescription.text = annotation.longDescription
        
        if isFavorite(place: annotation) {
            favoriteButton.isSelected = true
        } else {
            favoriteButton.isSelected = false
        }
        
        if let place = view.annotation as? Place {
            currentPlace = place
        }
    }
    
    func isFavorite(place: Place) -> Bool {
        let names = DataManager.sharedInstance.listFavorites()
        for name in names {
            if place.name == name {
                return true
            }
        }
        
        return false
    }
    
    @IBAction func markFavoriteButtonPressed(_ sender: UIButton) {
        if locationTitle.text == "A Look at Chicago" {
            return
        }
        if favoriteButton.isSelected {
            favoriteButton.isSelected = false
            DataManager.sharedInstance.deleteFavorite(currentPlace: currentPlace.name!)
        } else {
            favoriteButton.isSelected = true
            DataManager.sharedInstance.saveFavorite(currentPlace: currentPlace.name!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FavoritesViewController
        
        destination.annotations = self.annotations
        destination.delegate = self
    }
}

// https://iosdevcenters.blogspot.com/2017/11/what-is-protocol-how-to-pop-data-using.html
extension MapViewController: PlacesFavoritesDelegate {
    func selectedFavoritePlace(place: Place) {
        mapView.selectAnnotation(place, animated: true)
        
        let regionData = DataManager.sharedInstance.loadChicagoData()
        let currentPlaceLongLat = CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!)
        let currentPlaceSpan = MKCoordinateSpan(latitudeDelta: regionData.latDelta!, longitudeDelta: regionData.longDelta!)
        let currentRegion = MKCoordinateRegion(center: currentPlaceLongLat, span: currentPlaceSpan)
        mapView.setRegion(currentRegion, animated: true)
    }
}

