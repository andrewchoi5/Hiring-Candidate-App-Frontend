//
//  EventTypeCell.swift
//  App
//
//  Created by Omid on 2016-08-22.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class EventTypeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var eventType: EventType? {
        
        didSet {
            self.nameLabel.text = self.eventType?.name ?? " "
        }
    }
}
