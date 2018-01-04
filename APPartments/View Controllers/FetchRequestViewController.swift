//
//  FetchRequestViewController.swift
//  APPartments
//
//  Created by Heather Corey on 1/4/18.
//  Copyright © 2018 Heather Corey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    IBOutlets
    
    @IBOutlet weak var fetchedDataTableView: UITableView!
    
//    Properties
    
    var locations: [Location] = []
    
//    Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fetchedDataCell", for: indexPath) as! FetchedDataTableViewCell
        
        cell.locationLatitude = String(locations[indexPath.row].latitude)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = getLocations()
        printLocations()
    }
    
    private func getLocations() -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Location.timestamp), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func printLocations() {
        for location in locations {
            print("Latitude: \(location.latitude)")
            print("Longitude: \(location.longitude)")
            print("Timstamp: \(location.timestamp!)")
        }
    }
    
}
