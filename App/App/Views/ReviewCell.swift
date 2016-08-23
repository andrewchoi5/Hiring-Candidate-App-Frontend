//
//  ReviewCell.swift
//  App
//
//  Created by Chelsea Thiel-Jones on 2016-08-19.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var flagView: UIView!
    
    var review: Review? {
        
        didSet {
            self.initialLabel.text = String(self.review?.user?.firstname?.characters.first ?? " ").uppercaseString + String(self.review?.user?.lastname?.characters.first ?? " ").uppercaseString
            self.nameLabel.text = String(format: NSLocalizedString("by %@", comment: ""), self.review?.user?.name ?? " ")
            self.noteLabel.text = self.review?.note ?? " "
            
            self.initialLabel.text = "OM"
            self.nameLabel.text = "by Omid Moghadam"
            self.noteLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        }
    }
}
