//
//  RouteDetailsViewController.swift
//  APPartments
//
//  Created by Heather Corey on 1/7/18.
//  Copyright © 2018 Heather Corey. All rights reserved.
//

import UIKit
import CoreData


class RouteDetailsViewController: UIViewController {
    
    var chosenRoute: Route!
    
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        urlTextView.text = chosenRoute.userDefinedDescription
        
        let minLat = chosenRoute.minLat
        let maxLat = chosenRoute.maxLat
        let minLong = chosenRoute.minLong
        let maxLong = chosenRoute.maxLong
        
        print("MinLat: \(minLat)")
        print("MaxLat: \(maxLat)")
        print("MinLong: \(minLong)")
        print("MaxLong: \(maxLong)")
        
        
        urlSet(minLat: chosenRoute.minLat, maxLat: chosenRoute.maxLat, minLong: chosenRoute.minLong, maxLong: chosenRoute.maxLong)
    }
    
    func urlSet(minLat: Double, maxLat: Double, minLong: Double, maxLong: Double) {
        guard let url = URL(string: "https://www.zillow.com/homes/for_sale/fsba,fsbo,fore,new_lt/0_fr/1_fs/1_pnd/\(maxLat),\(maxLong),\(minLat),\(minLong)_rect/0_mmm/_rect/0_mmm/") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
