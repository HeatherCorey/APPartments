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
    var routes: [Route] = []
    var chosenRoute: Route?
    
//    Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fetchedDataCell", for: indexPath) as! FetchedDataTableViewCell

        cell.routeDescription.text = routes[indexPath.row].userDefinedDescription
        chosenRoute = routes[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = getLocations()
        routes = getRoutes()
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
    
    private func getRoutes() -> [Route] {
        let fetchRequest: NSFetchRequest<Route> = Route.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Route.timestamp), ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if let destinationViewController = segue.destination as? RouteDetailsViewController {
            destinationViewController.chosenRoute = chosenRoute
        }
    }
    
    
}
