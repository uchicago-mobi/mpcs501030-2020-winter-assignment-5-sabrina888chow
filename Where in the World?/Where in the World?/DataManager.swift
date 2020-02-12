//
//  DataManager.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/10/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit

// https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift
public class DataManager {
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    var favoritePlaces: [String] = []
    let favorites = UserDefaults.standard
    
    //This prevents others from using the default '()' initializer
    fileprivate init() {}
    
    struct PlaceData: Codable {
        var name: String?
        var description: String?
        var lat: Double?
        var long: Double?
        var type: Int?
    }
    
    struct RootData: Codable {
        var places: [PlaceData]?
        var region: [Double]?
    }
    
    struct Location: Codable {
        var lat: Double?
        var long: Double?
        var latDelta: Double?
        var longDelta: Double?
    }
    
    // Working with UserDefaults
    // https://learnappmaking.com/userdefaults-swift-setting-getting-data-how-to/
    // https://useyourloaf.com/blog/using-swift-codable-with-property-lists/
    func loadAnnotationFromPlist() -> [Place] {
        // https://stackoverflow.com/questions/35118301/cant-get-plist-url-in-swift
        guard let dataURL = Bundle.main.path(forResource: "Data", ofType: "plist") else { return [] }
        var currentData: RootData?
        if let data = try? Data(contentsOf: URL(fileURLWithPath: dataURL)) {
          let decoder = PropertyListDecoder()
          currentData = try? decoder.decode(RootData.self, from: data)
        }
        
        var annotations: [Place] = []
        
        if let allPlaces = currentData?.places {
            for place in allPlaces {
                let annotation = Place()
                annotation.name = place.name
                annotation.longDescription = place.description
                annotation.latitude = place.lat
                annotation.longitude = place.long
                annotation.type = place.type
                annotations.append(annotation)
            }
        }
        
        return annotations
    }
    
    func loadChicagoData() -> Location {
        var location = Location()
        
        guard let dataURL = Bundle.main.path(forResource: "Data", ofType: "plist") else { return location }
        var currentData: RootData?
        if let data = try? Data(contentsOf: URL(fileURLWithPath: dataURL)) {
          let decoder = PropertyListDecoder()
          currentData = try? decoder.decode(RootData.self, from: data)
        }
        
        if let region = currentData?.region {
            location.lat = region[0]
            location.long = region[1]
            location.latDelta = region[2]
            location.longDelta = region[3]
        }
        
        return location
    }
    
    func saveFavorite(currentPlace: String) {
        var current = favorites.array(forKey: "favorites") as? [String] ?? [String]()
        current.append(currentPlace)
        favorites.set(current, forKey: "favorites")
    }
    
    func deleteFavorite(currentPlace: String) {
        var current = favorites.array(forKey: "favorites") as? [String] ?? [String]()
        if let index = current.firstIndex(of: currentPlace) {
            current.remove(at: index)
        }
        favorites.set(current, forKey: "favorites")
    }
    
    func listFavorites() -> [String] {
        return favorites.array(forKey: "favorites") as? [String] ?? [String]()
    }
}
