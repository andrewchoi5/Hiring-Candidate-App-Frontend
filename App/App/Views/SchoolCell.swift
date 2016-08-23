//
//  SchoolCell.swift
//  App
//
//  Created by Omid on 2016-08-17.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class SchoolCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var school: School? {
        
        didSet {
            self.nameLabel.text = self.school?.name ?? " "
            self.locationLabel.text = self.school?.location ?? " "
        }
    }
}
