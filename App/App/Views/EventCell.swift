//
//  EventCell.swift
//  App
//
//  Created by Sonalee Shah on 2016-08-09.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var event: Event? {
        
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            
            self.nameLabel.text = self.event?.name ?? " "
            self.typeLabel.text = self.event?.eventType?.name ?? " "
            self.locationLabel.text = String(format: NSLocalizedString("%@ (%@)", comment: ""), dateFormatter.stringFromDate(self.event?.date ?? NSDate()), (self.event?.location ?? ""))
        }
    }
}
