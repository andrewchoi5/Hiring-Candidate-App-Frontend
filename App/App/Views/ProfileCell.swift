//
//  ProfileCell.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var flagView: UIView!
    
    var profile: Profile? {
        
        didSet {
            self.initialLabel.text = String(self.profile?.firstname?.characters.first ?? " ").uppercaseString + String(self.profile?.lastname?.characters.first ?? " ").uppercaseString
            self.nameLabel.text = self.profile?.name ?? " "
            self.schoolLabel.text = self.profile?.school?.name ?? " "
        }
    }
}
