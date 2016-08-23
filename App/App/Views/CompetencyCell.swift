//
//  CompetencyCell.swift
//  App
//
//  Created by Chelsea Thiel-Jones on 2016-08-19.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class CompetencyCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!

    var value: Int = 0 {
        
        didSet {
            let selectedColor = UIColor(hex: 0x498fe1ff)
            let unselectedColor = UIColor(hex: 0xd7d7d7ff)
            
            self.firstButton.backgroundColor = self.value > 0 ? selectedColor : unselectedColor
            self.secondButton.backgroundColor = self.value > 1 ? selectedColor : unselectedColor
            self.thirdButton.backgroundColor = self.value > 2 ? selectedColor : unselectedColor
            self.fourthButton.backgroundColor = self.value > 3 ? selectedColor : unselectedColor
            self.fifthButton.backgroundColor = self.value > 4 ? selectedColor : unselectedColor
        }
    }
}
