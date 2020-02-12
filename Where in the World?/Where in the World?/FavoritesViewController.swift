//
//  FavoritesViewController.swift
//  Where in the World?
//
//  Created by Cassidy Reyes on 2/10/20.
//  Copyright © 2020 Sabrina Chow. All rights reserved.
//

import UIKit

// https://iosdevcenters.blogspot.com/2017/11/what-is-protocol-how-to-pop-data-using.html
protocol PlacesFavoritesDelegate: class {
    func selectedFavoritePlace(place: Place) -> Void
}

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var exitButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: PlacesFavoritesDelegate?
    
    var annotations: [Place] = []
    var favorites: [Place] = []
    let titles = DataManager.sharedInstance.listFavorites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        for title in titles {
            for annotation in annotations {
                if title == annotation.title {
                    favorites.append(annotation)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleStyle", for: indexPath)
        
        let currentFavorite = favorites[indexPath.row]
        cell.textLabel?.text = currentFavorite.title
        cell.detailTextLabel?.text = currentFavorite.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate!.selectedFavoritePlace(place: annotations[indexPath.row])
        // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
