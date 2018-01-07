//
//  NewRouteViewController.swift
//  APPartments
//
//  Created by Heather Corey on 1/2/18.
//  Copyright © 2018 Heather Corey. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class NewRouteViewController: UIViewController {
//    IBOutlets
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routingLabel: UILabel!
    
//    Properties
    
    private var route: Route!
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var routeDescription: UITextField?
    
//    Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
        seconds += 1
    }
    
    
    private func startRoute() {
        startButton.isHidden = true
        stopButton.isHidden = false
        routingLabel.text = "Routing Now"
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRoute() {
        startButton.isHidden = true
        stopButton.isHidden = false
//        mapContainerView.isHidden = true
        locationManager.stopUpdatingLocation()
    }
    
    private func saveRoute() {
        let newRoute = Route(context: CoreDataStack.context)
        newRoute.distance = distance.value
        newRoute.duration = Int16(seconds)
        newRoute.timestamp = Date()
        newRoute.userDefinedDescription = routeDescription?.text
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRoute.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        route = newRoute
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    
//    IBActions
    
    @IBAction func startTapped(_ sender: UIButton) {
        startRoute()
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "End route?",
                                                message: "Please enter a short description of your route:",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addTextField()
        routeDescription = alertController.textFields![0]
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRoute()
            self.saveRoute()
            self.performSegue(withIdentifier: "fetchRequestSegue", sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRoute()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
   
}

extension NewRouteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
            print(locationList)
        }
    }
}

extension NewRouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
