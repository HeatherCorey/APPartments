//
//  RouteDetailsViewController.swift
//  APPartments
//
//  Created by Heather Corey on 1/7/18.
//  Copyright © 2018 Heather Corey. All rights reserved.
//

import UIKit

class RouteDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var urlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        // Do any additional setup after loading the view.
    }
    
    func getCoordinates() {
        
    }
    
    func urlSet() {
        guard let url = URL(string: "http://www.google.com") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func sendQueryAction(_ sender: UIButton) {
        
        urlSet()
    }
    
}
