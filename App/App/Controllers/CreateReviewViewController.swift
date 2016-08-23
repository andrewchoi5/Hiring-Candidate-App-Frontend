//
//  CreateReviewViewController.swift
//  App
//
//  Created by Omid on 2016-08-22.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class CreateReviewViewController: BaseViewController {
    
    var profile: Profile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Add Review", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CreateReviewViewController.doneButtonTapped(_:)))
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
    }
}