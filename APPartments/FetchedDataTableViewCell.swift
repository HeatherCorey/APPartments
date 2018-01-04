//
//  FetchedDataTableViewCell.swift
//  APPartments
//
//  Created by Heather Corey on 1/4/18.
//  Copyright © 2018 Heather Corey. All rights reserved.
//

import UIKit
import CoreData

class FetchedDataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var fetchedDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var locationLatitude: String = "" {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        fetchedDataLabel.text = locationLatitude
    }

}
