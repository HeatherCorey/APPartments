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
    
//    Properties
    
    private var route: Route!
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.miles)
    private var locationList: [CLLocation] = []
    
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
//        updateDisplay()
    }
    
    private func startRoute() {
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
//        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRoute() {
//        mapContainerView.isHidden = true
        locationManager.stopUpdatingLocation()
    }
    
    private func saveRoute() {
        let newRoute = Route(context: CoreDataStack.context)
        newRoute.distance = distance.value
        newRoute.duration = Int16(seconds)
        newRoute.timestamp = Date()
        
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
                                                message: "Do you wish to end your route?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRoute()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRoute()
            self.saveRoute()
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
            }
            
            locationList.append(newLocation)
        }
    }
}
