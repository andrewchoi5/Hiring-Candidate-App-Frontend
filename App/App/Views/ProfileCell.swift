//
//  ProfileCell.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var flagView: UIView!
    
    var profile: Profile? {
        
        didSet {
            self.nameLabel.text = (self.profile?.firstname ?? "") + " " + (self.profile?.lastname ?? "")
            self.schoolLabel.text = self.profile?.school
        }
    }
}
