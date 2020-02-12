//
//  DataManager.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/10/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit

public class DataManager {
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    var favoritePlaces: [Place] = []
    
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
    
    // Your code (these are just example functions, implement what you need)
    
    
    // https://useyourloaf.com/blog/using-swift-codable-with-property-lists/
    func loadAnnotationFromPlist() -> [Place] {
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
    
    func saveFavorite(place: Place) {
        let favorites = UserDefaults.standard
        favorites.set(place, forKey: "\(String(describing: place.name))")
        
        /*let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Data.plist")

        do {
            let data = try encoder.encode(favorites)
            try data.write(to: path)
        } catch {
            print(error)
        }*/
    }
    
    func deleteFavorite(place: Place) {
        let favorites = UserDefaults.standard
        favorites.removeObject(forKey: "\(String(describing: place.name))")
    }
    
    func listFavorites() {}
}
